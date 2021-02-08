use codespan::{FileId, Files};
use crate::common_structs::{NixpkgsHammerMessage};
use std::{collections::HashMap, error::Error, fs};
use rnix::{types::*, SyntaxNode};

pub type Report = Vec<NixpkgsHammerMessage>;
pub type FileAnalyzer = fn(&Files<String>, FileId) -> Result<Report, Box<dyn Error>>;

/// Runs given analyzer on passed files.
pub fn analyze_files(filenames: Vec<String>, analyzer: FileAnalyzer) -> Result<String, Box<dyn Error>> {
    let mut report = HashMap::new();

    let mut files = Files::new();
    for filename in filenames {
        let file_id = files.add(filename.clone(), fs::read_to_string(&filename)?);
        report.insert(filename.clone(), analyzer(&files, file_id)?);
    }

    Ok(serde_json::to_string(&report)?)
}

/// Parses a Nix file and returns a root AST node.
pub fn find_root(
    files: &Files<String>,
    file_id: FileId,
) -> Result<SyntaxNode, String> {
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
