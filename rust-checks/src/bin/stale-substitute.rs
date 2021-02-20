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
    let re = Regex::new(
        r"substituteStream\(\): WARNING: pattern (.*?) doesn't match anything in file '(.*?)'",
    )
    .unwrap();

    let report = log
        .lines()
        .filter_map(|line| {
            re.find(&line.unwrap())
                .and_then(|m| Some(m.as_str().to_string()))
        })
        .map(|m| NixpkgsHammerMessage {
            msg: format!("Stale substituteInPlace detected.\n{}", m),
            name: "stale-substitute",
            locations: vec![],
            link: true,
        })
        .collect();

    Ok(report)
}
