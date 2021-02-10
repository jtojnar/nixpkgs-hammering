use codespan::{FileId, Files};
use nixpkgs_hammering_ast_checks::analysis::*;
use nixpkgs_hammering_ast_checks::common_structs::{NixpkgsHammerMessage, SourceLocation};
use rnix::SyntaxKind::*;
use std::{env, error::Error};
use nixpkgs_hammering_ast_checks::tree_utils::walk_kind;

fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<String> = env::args().skip(1).collect();
    println!("{}", analyze_files(args, analyze_single_file)?);
    Ok(())
}

fn analyze_single_file(
    files: &Files<String>,
    file_id: FileId,
) -> Result<Report, Box<dyn Error>> {
    let root = find_root(files, file_id)?;
    let mut report: Report = vec![];

    // Find all URI literals and report them.
    for uri in walk_kind(&root, TOKEN_URI) {
        let start = uri.text_range().start().to_usize() as u32;

        report.push(NixpkgsHammerMessage {
            msg: "URI literals are deprecated.".to_string(),
            name: "no-uri-literals",
            locations: vec![SourceLocation::from_byte_index(files, file_id, start)?],
            link: true,
        });
    }

    Ok(report)
}
