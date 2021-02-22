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
    let re = Regex::new(r"Ran 0 tests in 0.000s").unwrap();

    let report = match log.lines().any(|l| re.is_match(&l.unwrap())) {
        true => vec![NixpkgsHammerMessage {
            msg: "Test runner could not discover any test cases: 'Ran 0 tests in 0.000s'"
                .to_string(),
            name: "no-python-tests",
            locations: vec![],
            link: true,
        }],
        false => vec![],
    };

    Ok(report)
}
