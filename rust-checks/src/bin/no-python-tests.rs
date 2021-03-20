use nixpkgs_hammering_ast_checks::analysis::*;
use nixpkgs_hammering_ast_checks::common_structs::*;
use regex::Regex;
use std::error::Error;
use std::io::{self, BufRead, BufReader};
use std::process::ChildStdout;

fn main() -> Result<(), Box<dyn Error>> {
    let attrs: Vec<Attr> = serde_json::from_reader(io::stdin())?;
    println!("{}", analyze_log_files(attrs, analyze_single_file)?);
    Ok(())
}

fn analyze_single_file(log: BufReader<ChildStdout>, attr: &Attr) -> Result<Report, Box<dyn Error>> {
    // Looking for two kinds of messages in the log that indicate no tests were run. The
    // first is from `setuptoolsCheckPhase`, and looks like

    // running build_ext
    // ----------------------------------------------------------------------
    // Ran 0 tests in 0.000s
    // OK
    // Finished executing setuptoolsCheckPhase

    // The second is from pytest (either invoked manually or from pytestCheckHook)
    // and looks like
    // ============================= test session starts ==============================
    // platform linux -- Python 3.8.8, pytest-6.2.2, py-1.9.0, pluggy-0.13.1
    // rootdir: /build/humanize-3.1.0, configfile: tox.ini
    // collected 0 items
    // ============================ no tests ran in 0.00s =============================
    let re = Regex::new(r"(Ran 0 tests|no tests ran\x1b\[0m\x1b\[33m) in \d+.\d+s").unwrap();
    let ansi_escape = Regex::new(r"\x1b\[0m\x1b\[33m").unwrap();

    let report = log
        .lines()
        .filter_map(|line| line.ok())
        .filter_map(|s| re.find(&s).and_then(|m| Some(m.as_str().to_string())))
        .map(|m| NixpkgsHammerMessage {
            msg: format!(
                "Test runner could not discover any test cases: ‘{}’",
                ansi_escape.replace(&m, "")
            ),
            name: "no-python-tests",
            locations: attr.location.iter().map(|x| x.clone()).collect(),
            link: true,
        })
        .collect();

    Ok(report)
}
