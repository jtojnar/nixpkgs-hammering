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

fn analyze_single_file(log: BufReader<ChildStdout>) -> Result<Report, Box<dyn Error>> {
    let re = Regex::new(r"Ran 0 tests in \d+.\d+s").unwrap();

    let report = log
        .lines()
        .filter_map(|line| line.ok())
        .filter_map(|s| re.find(&s).and_then(|m| Some(m.as_str().to_string())))
        .map(|m| NixpkgsHammerMessage {
            msg: format!("Test runner could not discover any test cases: ‘{}’", m),
            name: "no-python-tests",
            locations: vec![],
            link: true,
        })
        .collect();

    Ok(report)
}
