use clap::Parser;
use nixpkgs_hammering::{hammer, Config};
use std::{collections::HashSet, path::PathBuf};

/// Check package expressions for common mistakes.
#[derive(Parser, Debug)]
struct Args {
    /// Evaluate attributes in given path.
    ///
    /// The path needs to be importable by Nix and the imported value
    /// has to accept attribute set with overlays attribute as an argument.
    ///
    /// Defaults to current working directory.
    #[arg(long, short = 'f', value_name = "FILE")]
    file: Option<PathBuf>,

    /// Show trace when error occurs.
    #[arg(long, default_value_t = false)]
    show_trace: bool,

    /// Avoid catching evaluation errors (for debugging).
    #[arg(long, default_value_t = false)]
    do_not_catch_errors: bool,

    /// Output results as JSON.
    #[arg(long, default_value_t = false)]
    json: bool,

    /// Rule to exclude (can be passed repeatedly).
    #[arg(long, short = 'e', value_name = "rule")]
    excluded: Vec<String>,

    /// Attribute path of package to check.
    #[arg(value_name = "attr-path", required = true)]
    attr_paths: Vec<String>,
}

fn main() -> Result<(), String> {
    let Args {
        file,
        show_trace,
        do_not_catch_errors,
        json,
        excluded,
        attr_paths,
    } = Args::parse();

    // Absolutize so we can refer to it from Nix.
    let nix_file = if let Some(file) = file {
        file.canonicalize().map_err(|err| {
            format!(
                "Unable to resolve path to Nix expression: {}",
                err.to_string()
            )
        })?
    } else {
        std::env::current_dir().map_err(|err| {
            format!(
                "Unable to determine current working directory: {}",
                err.to_string()
            )
        })?
    };

    hammer(Config {
        nix_file,
        show_trace,
        do_not_catch_errors,
        json,
        excluded_rules: HashSet::from_iter(excluded),
        attr_paths,
    })
}
