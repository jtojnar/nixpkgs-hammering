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
    let re = Regex::new(r"substituteStream\(\): WARNING: pattern (.*?) doesn't match anything in file '(.*?)'").unwrap();

    let report = match log.lines().any(|l| re.is_match(&l.unwrap())) {
        true => vec![NixpkgsHammerMessage {
            msg: "Stale substituteInPlace detected"
                .to_string(),
            name: "stale-substitute",
            locations: vec![],
            link: true,
        }],
        false => vec![],
    };

    Ok(report)
}
