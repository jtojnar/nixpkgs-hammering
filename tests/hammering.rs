use serde_json::Value;
use std::collections::HashMap;
use std::ffi::OsStr;
use std::process::{Command, Output, Stdio};

fn run_command<S, I>(program: S, args: I, envs: HashMap<&str, &str>) -> Result<Output, String>
where
    S: AsRef<OsStr>,
    I: IntoIterator<Item = S>,
{
    let child = Command::new(&program)
        .args(args)
        .stdout(Stdio::piped())
        .envs(envs)
        .spawn()
        // todo: use display method once stabilized in 1.87.0
        // https://github.com/rust-lang/rust/issues/120048
        .map_err(|err| format!("Unable to spawn program ‘{:?}’: {err}", program.as_ref()))?;

    child
        .wait_with_output()
        .map_err(|err| format!("Unable to wait on ‘{:?}’: {err}", program.as_ref()))
}

fn make_test_variant(
    rule: String,
    variant: Option<String>,
    should_match: bool,
    prebuild: bool,
) -> Result<(), String> {
    let attr_path = match variant {
        Some(variant) => format!("{rule}.{variant}"),
        None => rule.clone(),
    };

    if prebuild {
        run_command(
            "nix-build",
            ["--no-out-link", "./tests", "-A", &attr_path],
            HashMap::default(),
        )?;
    }

    let envs = HashMap::from([("NIXPKGS_HAMMERING_FATAL_EVAL_ISSUES", "1")]);

    let nixpkgs_hammer_path = env!("CARGO_BIN_EXE_nixpkgs-hammer");
    let test_build_output = run_command(
        nixpkgs_hammer_path,
        ["-f", "./tests", "--json", &attr_path],
        envs,
    )?;

    if !test_build_output.status.success() {
        return Err(format!(
            "error building the test: {}",
            String::from_utf8_lossy(&test_build_output.stdout)
        ));
    }

    let report: serde_json::Value =
        serde_json::from_slice(&test_build_output.stdout).map_err(|err| err.to_string())?;
    let matches = report
        .get(&attr_path)
        .and_then(Value::as_array)
        .map(|checks| checks.iter().any(|check| check["name"] == rule))
        .unwrap_or_default();

    if should_match && !matches {
        return Err("error matching the rule".to_string());
    } else if !should_match && matches {
        return Err("rule should not match".to_string());
    }

    Ok(())
}

macro_rules! make_test_rule {
    (
        $name:ident
    ) => {
        #[test]
        #[allow(non_snake_case)]
        fn $name() -> Result<(), String> {
            make_test_variant(
                stringify!($name).replace("_", "-"),
                None,
                true,
                false,
            )
        }
    };

    (
        $name:ident,
        [$($matching_variant:ident),* $(,)?] $(,)?
        $([$($nonmatching_variant:ident),* $(,)?] $(,)?)?
        $(prebuild = $prebuild:literal $(,)?)?
    ) => {
        #[allow(non_snake_case)]
        mod $name {
            use super::make_test_variant;

            const PREBUILD: bool = make_test_rule!(@prebuild, $($prebuild)?);

            $(
                #[test]
                #[allow(non_snake_case)]
                fn $matching_variant() -> Result<(), String> {
                    make_test_variant(
                        stringify!($name).replace("_", "-"),
                        Some(stringify!($matching_variant).replace("_", "-")),
                        true,
                        PREBUILD,
                    )
                }
            )*
            $($(
                #[test]
                #[allow(non_snake_case)]
                fn $nonmatching_variant() -> Result<(), String> {
                    make_test_variant(
                        stringify!($name).replace("_", "-"),
                        Some(stringify!($nonmatching_variant).replace("_", "-")),
                        false,
                        PREBUILD,
                    )
                }
            )*)?
        }
    };


    (@prebuild, $prebuild:literal) => {
        $prebuild
    };

    (@prebuild, ) => {
        false
    };
}

make_test_rule!(AttrPathNotFound, [foobarbaz]);

make_test_rule!(
    attribute_ordering,
    [out_of_order],
    [inherited, properly_ordered],
);

make_test_rule!(
    attribute_typo,
    [casing, deletion, insertion, transposition],
    [properly_ordered, unknown_short],
);

make_test_rule!(
    build_tools_in_build_inputs,
    [cmake, meson, ninja, pkg_config, sphinx],
);

// make_test_rule!(duplicate_check_inputs);

make_test_rule!(
    environment_variables_go_to_env,
    [env_var, pkg_config_var],
    [env_vars_just_in_env, no_env_vars],
);

make_test_rule!(EvalError, [exception], [no_exception]);

make_test_rule!(explicit_phases, [configure, build, check, install]);

make_test_rule!(fixup_phase);

make_test_rule!(
    license_missing,
    [no_license, empty_license, no_meta],
    [have_license],
);

make_test_rule!(
    maintainers_missing,
    [no_maintainers, empty_maintainers, no_meta],
    [have_maintainers],
);

make_test_rule!(meson_cmake);

make_test_rule!(
    missing_patch_comment,
    [missing_comment, comment_after_newline],
    [
        general_comment,
        comment_above,
        comment_inline,
        comment_within,
        complex_structure1,
        ignore_nested_lists1,
        ignore_nested_lists2,
    ],
);

make_test_rule!(
    missing_phase_hooks,
    [
        configure_pre,
        configure_post,
        configure_both,
        build_pre,
        build_post,
        build_both,
        check_pre,
        check_post,
        check_both,
        install_pre,
        install_post,
        install_both,
    ],
);

make_test_rule!(name_and_version, [positive], [negative, everything]);

make_test_rule!(no_flags_array, [make, make_finalAttrs]);

make_test_rule!(no_flags_spaces, [bad], [okay, nonstring]);

make_test_rule!(no_uri_literals, [uri_literal], [string]);

make_test_rule!(patch_phase);

make_test_rule!(
    python_explicit_check_phase,
    [
        // redundant_pytest,
    ],
    [nonredundant_pytest],
);

make_test_rule!(
    python_imports_check_typo,
    [
        // pythonImportTests,
        // pythonImportCheck,
        // pythonImportsTest,
        // pythonCheckImports,
    ],
    [pythonImportsCheck],
);

make_test_rule!(
    python_include_tests,
    [
        // no_tests_no_import_checks,
        // tests_disabled_no_import_checks,
    ],
    [pytest_check_hook, explicit_check_phase, has_imports_check],
);

make_test_rule!(
    python_inconsistent_interpreters,
    [
        // mixed_checkInputs,
        // mixed_propagatedBuildInputs,
    ],
    [normal],
);

make_test_rule!(stale_substitute, [stale], [live], prebuild = true);

make_test_rule!(
    unnecessary_parallel_building,
    [cmake, meson, qmake, qt_derivation],
);

make_test_rule!(
    unclear_gpl,
    [
        gpl2, gpl3, lgpl2, lgpl21, lgpl3,
        // lgpl3_python,
    ],
    [single_nonmatching_license],
);

make_test_rule!(
    unused_argument,
    [
        unused_pattern,
        unused_pattern_var_as_key,
        unused_pattern_var_in_let_binding,
    ],
    [
        used_pattern,
        used_single,
        unused_single,
        used_in_string1,
        used_in_string2,
        used_in_defaults,
    ],
);
