use codespan::{FileId, Files};
use nixpkgs_hammering_ast_checks::{
    analysis::*,
    common_structs::{CheckedAttr, NixpkgsHammerMessage, SourceLocation},
    tree_utils::walk_kind,
};
use rnix::SyntaxKind::*;
use std::{error::Error, io};

fn main() -> Result<(), Box<dyn Error>> {
    let attrs: Vec<CheckedAttr> = serde_json::from_reader(io::stdin())?;
    println!("{}", analyze_nix_files(attrs, analyze_single_file)?);
    Ok(())
}

fn analyze_single_file(files: &Files<String>, file_id: FileId) -> Result<Report, Box<dyn Error>> {
    let root = find_root(files, file_id)?;
    let mut report: Report = vec![];

    // Find all URI literals and report them.
    for uri in walk_kind(&root, TOKEN_URI) {
        let start: u32 = uri.text_range().start().into();

        report.push(NixpkgsHammerMessage {
            msg: "URI literals are deprecated.".to_string(),
            name: "no-uri-literals",
            locations: vec![SourceLocation::from_byte_index(files, file_id, start)?],
            link: true,
        });
    }

    Ok(report)
}
