use crate::common_structs::{CheckedAttr, NixpkgsHammerMessage};
use codespan::{FileId, Files};
use rnix::{Root, SyntaxNode};
use rowan::ast::AstNode as _;
use std::{
    collections::HashMap,
    error::Error,
    fs,
    io::BufReader,
    path::Path,
    process::{ChildStdout, Command, Stdio},
};

pub type Report = Vec<NixpkgsHammerMessage>;
pub type NixFileAnalyzer = fn(&Files<String>, FileId) -> Result<Report, Box<dyn Error>>;
pub type LogFileAnalyzer =
    fn(BufReader<ChildStdout>, &CheckedAttr) -> Result<Report, Box<dyn Error>>;

/// Runs given analyzer the nix file for each attr
pub fn analyze_nix_files(
    attrs: Vec<CheckedAttr>,
    analyzer: NixFileAnalyzer,
) -> Result<String, Box<dyn Error>> {
    let mut report: HashMap<String, Report> = HashMap::new();

    let mut files = Files::new();
    for attr in attrs.iter().filter(|a| a.location.is_some()) {
        let filename = attr.location.as_ref().unwrap().file.clone();
        let file_id = files.add(filename.clone(), fs::read_to_string(&filename)?);
        report.insert(attr.name.clone(), analyzer(&files, file_id)?);
    }

    Ok(serde_json::to_string(&report)?)
}

/// Runs given analyzer on log file for each attr, if exists
pub fn analyze_log_files(
    attrs: Vec<CheckedAttr>,
    analyzer: LogFileAnalyzer,
) -> Result<String, Box<dyn Error>> {
    let mut report: HashMap<String, Report> = HashMap::new();

    for attr in attrs
        .iter()
        .filter(|a| a.output.is_some())
        .filter(|a| Path::new(&a.output.as_ref().unwrap()).exists())
    {
        let mut program = Command::new("nix")
            .args(&[
                "--experimental-features",
                "nix-command",
                "log",
                &attr.output.as_ref().unwrap(),
            ])
            .stdout(Stdio::piped())
            .spawn()?;

        let logreader = BufReader::new(program.stdout.take().unwrap());
        let checkresult = analyzer(logreader, &attr)?;
        report.insert(attr.name.clone(), checkresult);
    }

    Ok(serde_json::to_string(&report)?)
}

/// Parses a Nix file and returns a root AST node.
pub fn find_root(files: &Files<String>, file_id: FileId) -> Result<SyntaxNode, String> {
    let root = Root::parse(files.source(file_id)).ok().map_err(|_| {
        format!(
            "Unable to parse {} as a nix file",
            files
                .name(file_id)
                .to_str()
                .unwrap_or("unprintable file, encoding error")
        )
    })?;

    let expr = root.expr().ok_or(format!(
        "No elements in the AST in path {}",
        files
            .name(file_id)
            .to_str()
            .unwrap_or("unprintable file, encoding error")
    ))?;

    Ok(expr.syntax().clone())
}
