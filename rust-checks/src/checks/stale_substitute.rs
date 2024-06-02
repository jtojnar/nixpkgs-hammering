use crate::{analysis::*, common_structs::*};
use regex::Regex;
use std::{
    error::Error,
    io::{BufRead, BufReader},
    process::ChildStdout,
};

pub fn run(attrs: Vec<CheckedAttr>) -> Result<String, Box<dyn Error>> {
    analyze_log_files(attrs, analyze_single_file)
}

fn analyze_single_file(
    log: BufReader<ChildStdout>,
    attr: &CheckedAttr,
) -> Result<Report, Box<dyn Error>> {
    let re = Regex::new(
        r"substituteStream\(\) in derivation .+: WARNING: pattern (.*?) doesn't match anything in file '(.*?)'",
    )
    .unwrap();

    let report = log
        .lines()
        .filter_map(|line| line.ok())
        .filter_map(|s| re.find(&s).and_then(|m| Some(m.as_str().to_string())))
        .map(|m| NixpkgsHammerMessage {
            msg: format!("Stale substituteInPlace detected.\n{}", m),
            name: "stale-substitute",
            locations: attr.location.iter().map(|x| x.clone()).collect(),
            link: true,
        })
        .collect();

    Ok(report)
}
