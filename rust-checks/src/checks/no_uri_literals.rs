use crate::{analysis::*, common_structs::*, tree_utils::walk_kind};
use codespan::{FileId, Files};
use rnix::SyntaxKind::*;
use std::error::Error;

pub fn run(attrs: Vec<CheckedAttr>) -> Result<String, Box<dyn Error>> {
    analyze_nix_files(attrs, analyze_single_file)
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
