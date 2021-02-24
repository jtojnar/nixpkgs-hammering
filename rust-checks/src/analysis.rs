use crate::common_structs::{Attr, NixpkgsHammerMessage};
use codespan::{FileId, Files};
use rnix::{types::*, SyntaxNode};
use std::{collections::HashMap, error::Error, fs};

pub type Report = Vec<NixpkgsHammerMessage>;
pub type NixFileAnalyzer = fn(&Files<String>, FileId) -> Result<Report, Box<dyn Error>>;

/// Runs given analyzer the nix file for each attr
pub fn analyze_nix_files(
    attrs: Vec<Attr>,
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

/// Parses a Nix file and returns a root AST node.
pub fn find_root(files: &Files<String>, file_id: FileId) -> Result<SyntaxNode, String> {
    let ast = rnix::parse(files.source(file_id))
        .as_result()
        .map_err(|_| {
            format!(
                "Unable to parse {} as a nix file",
                files
                    .name(file_id)
                    .to_str()
                    .unwrap_or("unprintable file, encoding error")
            )
        })?;

    ast.root().inner().ok_or(format!(
        "No elements in the AST in path {}",
        files
            .name(file_id)
            .to_str()
            .unwrap_or("unprintable file, encoding error")
    ))
}
