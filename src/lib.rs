use indoc::formatdoc;
use model::{CheckedAttr, Report, Severity, SourceLocation};
use rust_checks::checks::{self, Check};
use serde::{Deserialize, Serialize};
use std::{
    collections::{HashMap, HashSet},
    fs::read_dir,
    path::PathBuf,
};
use utils::{indent, optional_env, run_command_with_input};

pub mod model;
pub mod utils;

#[derive(Debug)]
pub struct Config {
    pub nix_file: PathBuf,
    pub show_trace: bool,
    pub do_not_catch_errors: bool,
    pub json: bool,
    pub excluded_rules: HashSet<String>,
    pub attr_paths: Vec<String>,
}

fn get_overlays_dir() -> Result<PathBuf, String> {
    // Provided by wrapper.
    if let Some(dir) = optional_env("OVERLAYS_DIR")? {
        return Ok(PathBuf::from(dir));
    }

    // Running using `cargo run`.
    if let Some(dir) = optional_env("CARGO_MANIFEST_DIR")? {
        return Ok(PathBuf::from(&dir).join("overlays"));
    }

    Err("Either ‘OVERLAYS_DIR’ or ‘CARGO_MANIFEST_DIR’ environment variable expected.".to_owned())
}

fn get_checks(excluded_rules: &HashSet<String>) -> HashMap<String, Check> {
    checks::ALL
        .into_iter()
        .map(|(name, check)| (name.to_string(), check))
        .filter(|(name, _)| !excluded_rules.contains(name))
        .collect()
}

fn run_checks(
    attrs: &[CheckedAttr],
    excluded_rules: &HashSet<String>,
) -> Result<HashMap<String, Vec<Report>>, String> {
    let rules = get_checks(excluded_rules);
    if rules.is_empty() {
        return Ok(HashMap::new());
    }

    let encoded_attrs = serde_json::to_string(attrs)
        .map_err(|err| format!("Unable to serialize attrs: {}", err.to_string()))?;
    let mut result = HashMap::new();

    if !excluded_rules.contains("no-build-output") {
        let names_without_outputs = attrs
            .into_iter()
            .filter(|a| a.output.as_ref().is_some_and(|o| o.exists()))
            .map(|a| a.name.clone());
        for name in names_without_outputs {
            result
                .entry(name.clone())
                .or_insert_with(|| Vec::new())
                .push(Report {
                    name: "no-build-output".to_owned(),
                    msg: format!(
                        "‘{name}’ has not yet been built. \
                        Checks that rely on the presence of build logs are skipped."
                    ),
                    link: false,
                    locations: vec![],
                    severity: Severity::Notice,
                })
        }
    }

    let rc_attrs = attrs
        .iter()
        .map(|attr| attr.clone().try_into())
        .collect::<Result<Vec<_>, _>>()?;
    for (name, check) in rules {
        let json_text = check(rc_attrs.clone()).map_err(|err| {
            eprintln!(
                "{}",
                red(&format!(
                    "Rule ‘{name}’ failed with input ‘{encoded_attrs}’.\
                    This is a bug. Please file a ticket on GitHub."
                ))
            );

            format!("Unable to execute rule ‘{name}’: {}", err.to_string())
        })?;

        if !json_text.is_empty() {
            let results: HashMap<String, Vec<Report>> =
                serde_json::from_str(&json_text).map_err(|err| {
                    format!(
                        "Unable to parse result of rule ‘{name}’: {}",
                        err.to_string()
                    )
                })?;
            for (attr_name, reports) in results.into_iter() {
                result
                    .entry(attr_name)
                    .or_insert_with(|| Vec::new())
                    .extend(reports)
            }
        }
    }

    Ok(result)
}

fn concatenate_messages(
    report_sources: &mut [HashMap<String, Vec<Report>>],
) -> HashMap<String, Vec<Report>> {
    let mut result = HashMap::new();
    for m in report_sources.into_iter() {
        for (attr_name, mut report) in m.drain() {
            result
                .entry(attr_name.clone())
                .or_insert_with(|| Vec::new())
                .append(&mut report);
        }
    }
    result
}

fn escape_attr(attr: &str) -> String {
    attr.split(".")
        .map(|section| format!("\"{section}\""))
        .collect::<Vec<_>>()
        .join(".")
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct OverlayCheckResult {
    /// Location in which the attr is defined, if exist
    location: Option<SourceLocation>,
    /// Path to the .drv file, if exists
    drv_path: Option<PathBuf>,
    /// Path the the output of the drv in the nix store, if exists
    output_path: Option<PathBuf>,
    report: Vec<Report>,
}

fn nix_eval_json(
    expr: String,
    show_trace: bool,
) -> Result<HashMap<CheckedAttr, Vec<Report>>, String> {
    let mut args = vec!["--strict", "--json", "--eval", "-"];

    if show_trace {
        args.push("--show-trace");
    }

    let json_text = run_command_with_input("nix-instantiate", &args, &expr)?;

    let mut result = HashMap::new();
    let results: HashMap<String, OverlayCheckResult> =
        serde_json::from_str(&json_text).map_err(|err| {
            format!(
                "Unable to parse result of overlay checks: {} {json_text}",
                err.to_string()
            )
        })?;
    for (
        name,
        OverlayCheckResult {
            location,
            drv_path,
            output_path,
            mut report,
        },
    ) in results.into_iter()
    {
        let attr = CheckedAttr {
            name,
            output: output_path,
            drv: drv_path,
            location,
        };
        result
            .entry(attr)
            .or_insert_with(|| Vec::new())
            .append(&mut report);
    }

    Ok(result)
}

fn bold(msg: &str) -> String {
    format!("[1m{msg}[0m")
}

fn yellow(msg: &str) -> String {
    format!("[1;33m{msg}[0m")
}

fn red(msg: &str) -> String {
    format!("[1;31m{msg}[0m")
}

fn green(msg: &str) -> String {
    format!("[1;32m{msg}[0m")
}

fn render_code_location_ansi(loc: SourceLocation) -> String {
    let Ok(opened_file) = std::fs::read_to_string(&loc.file) else {
        return format!("Unable to load contents of file ‘{}’", loc.file.display());
    };
    let all_lines: Vec<_> = opened_file.split("\n").collect();
    let line_contents = all_lines[loc.line - 1];
    let line_no = loc.line.to_string();
    let line_spaces = " ".repeat(line_no.len());
    let column = loc.column.unwrap_or(1);
    let pointer = " ".repeat(column - 1) + "^";
    let mut rendered_loc_parts = vec![loc.file.to_string_lossy().to_string(), line_no.to_string()];
    if !loc.column.is_none() {
        let column_no = loc.line.to_string();
        rendered_loc_parts.push(column_no);
    }

    formatdoc!(
        "Near {}:
        {line_spaces} |
        {line_no} | {line_contents}
        {line_spaces} | {pointer}",
        rendered_loc_parts.join(":")
    )
}

fn render_report_ansi(report: Report) -> String {
    let color = if report.severity == Severity::Error {
        red
    } else {
        yellow
    };

    let mut message_lines = vec![
        color(&format!("{}: {}", report.severity, report.name)),
        report.msg,
    ];
    message_lines.extend(report.locations.into_iter().map(render_code_location_ansi));

    if report.link {
        message_lines.push(format!(
            "See: https://github.com/jtojnar/nixpkgs-hammering/blob/master/explanations/{}.md",
            report.name,
        ));
    }

    return message_lines.join("\n");
}

pub fn hammer(config: Config) -> Result<(), String> {
    let overlay_generators_path = get_overlays_dir()?;

    let try_eval = if config.do_not_catch_errors {
        "(value: { inherit value; success = true; })"
    } else {
        "builtins.tryEval"
    };

    let mut attr_messages = vec![];

    for attr in config.attr_paths {
        attr_messages.push(formatdoc!(
            r#"
            "{attr}" =
              let
                result = {try_eval} pkgs.{} or null;
                maybeReport = {try_eval} (result.value.__nixpkgs-hammering-state.reports or []);
              in
                if !(result.success && maybeReport.success) then
                  {{
                    report = [ {{
                      name = "EvalError";
                      msg = "Cannot evaluate attribute ‘{attr}’ in ‘${{packageSet}}’.";
                      severity = "warning";
                      link = false;
                    }} ];
                    location = null;
                    outputPath = null;
                    drvPath = null;
                  }}
                else if result.value == null then
                  {{
                    report = [ {{
                      name = "AttrPathNotFound";
                      msg = "Packages in ‘${{packageSet}}’ do not contain ‘{attr}’ attribute.";
                      severity = "error";
                      link = false;
                    }} ];
                    location = null;
                    outputPath = null;
                    drvPath = null;
                  }}
                else
                  {{
                    report = if maybeReport.success then maybeReport.value else [];
                    location =
                      let
                        position = result.value.meta.position or null;
                        posSplit = builtins.split ":" result.value.meta.position;
                      in
                        if position == null then
                          null
                        else {{
                          file = builtins.elemAt posSplit 0;
                          line = builtins.fromJSON (builtins.elemAt posSplit 2);
                        }};
                    outputPath = result.value.outPath;
                    drvPath = result.value.drvPath;
                  }};"#,
            escape_attr(&attr)
        ));
    }

    // Our overlays need to know the built attributes so that they can check only them.
    // We do it by using functions that return overlays so we need to instantiate them.
    let mut overlay_expressions = vec![];
    let generators = read_dir(&overlay_generators_path).map_err(|err| {
        format!(
            "Unable to list contents of overlays directory ‘{}’: {}",
            overlay_generators_path.display(),
            err.to_string()
        )
    })?;
    for overlay_generator in generators {
        let overlay_generator = overlay_generator.map_err(|err| {
            format!(
                "Error reading overlays directory contents: {}",
                err.to_string()
            )
        })?;
        if overlay_generator
            .path()
            .file_stem()
            .map(|stem| {
                config
                    .excluded_rules
                    .contains(&stem.to_string_lossy().to_string())
            })
            .unwrap_or(false)
        {
            continue;
        }

        let overlay = overlay_generator.path();
        let overlay = overlay.to_str().ok_or_else(|| {
            format!(
                "Overlay path ‘{}’ not valid UTF-8 string.",
                overlay.display()
            )
        })?;
        overlay_expressions.push(format!("(import {overlay})"));
    }

    let attr_messages_nix = if !attr_messages.is_empty() {
        "{\n".to_owned() + &indent(attr_messages.join("\n\n"), 1) + "\n}"
    } else {
        "{ }".to_owned()
    };
    let overlays_nix = if !overlay_expressions.is_empty() {
        "[\n".to_owned() + &indent(overlay_expressions.join("\n"), 1) + "\n]"
    } else {
        "[ ]".to_owned()
    };
    let nix_file = config.nix_file.to_str().ok_or_else(|| {
        format!(
            "Nix expression file path ‘{}’ not valid UTF-8 string.",
            config.nix_file.display(),
        )
    })?;
    let all_messages_nix = formatdoc!(
        "
        let
            packageSet = {nix_file};
            cleanPkgs = import packageSet {{ }};

            pkgs = import packageSet {{
                overlays = {};
            }};
        in {}
        ",
        indent(overlays_nix, 2).trim(),
        indent(attr_messages_nix, 0).trim()
    );

    if config.show_trace {
        eprintln!("Nix expression:\n{}", all_messages_nix);
    }

    let overlay_data = nix_eval_json(all_messages_nix, config.show_trace)?;
    let reports = run_checks(
        &overlay_data.keys().map(|k| k.clone()).collect::<Vec<_>>(),
        &HashSet::from_iter(config.excluded_rules),
    )?;
    let overlay_reports = HashMap::from_iter(
        overlay_data
            .into_iter()
            .map(|(attr, reports)| (attr.name, reports)),
    );
    let all_messages = concatenate_messages(&mut [overlay_reports, reports]);

    if config.json {
        let encoded_messages = serde_json::to_string(&all_messages)
            .map_err(|err| format!("Unable to serialize result messages: {}", err.to_string()))?;
        println!("{}", encoded_messages);
    } else {
        for (attr_name, reports) in all_messages.into_iter() {
            eprintln!(
                "{}",
                bold(&format!("When evaluating attribute ‘{attr_name}’:"))
            );
            if !reports.is_empty() {
                eprintln!(
                    "{}",
                    reports
                        .into_iter()
                        .map(render_report_ansi)
                        .collect::<Vec<_>>()
                        .join("\n")
                );
            } else {
                eprintln!("{}", green("No issues found."));
            }
            eprintln!("");
        }
    }

    Ok(())
}
