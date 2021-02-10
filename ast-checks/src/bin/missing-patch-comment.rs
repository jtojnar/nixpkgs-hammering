use codespan::{FileId, Files};
use nixpkgs_hammering_ast_checks::analysis::*;
use nixpkgs_hammering_ast_checks::comment_finders::{find_comment_above, find_comment_within};
use nixpkgs_hammering_ast_checks::common_structs::{NixpkgsHammerMessage, SourceLocation};
use rnix::types::*;
use std::{error::Error, env};
use nixpkgs_hammering_ast_checks::tree_utils::walk_keyvalues_filter_key;

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

    // Find all “patches” attrset attributes, that
    // *do not* have a comment directly above them.
    let patches_without_top_comment = walk_keyvalues_filter_key(&root, "patches").filter(|kv| {
        // Look for a comment directly above the `patches = …` line
        // (Interpreting that as a comment which applies to all patches.)
        find_comment_above(kv.node()).is_none()
    });

    // For each list of patches without a top comment,
    // produce a report for each patch that is missing a per-patch comment.
    for kv in patches_without_top_comment {
        report.extend(process_patch_list(kv, files, file_id)?);
    }

    Ok(report)
}

fn process_patch_list(
    kv: KeyValue,
    files: &Files<String>,
    file_id: FileId,
) -> Result<Report, Box<dyn Error>> {
    let mut report: Report = vec![];

    match kv.value().and_then(List::cast) {
        Some(value) => {
            // For each element in the list of patches, look for
            // a comment directly above the element or, if we don't see
            // one of those, look for a comment within AST of the element.
            for item in value.items() {
                let has_comment_above = find_comment_above(&item).is_some();
                let has_comment_within = find_comment_within(&item).is_some();

                if !(has_comment_above || has_comment_within) {
                    let start = item.text_range().start().to_usize() as u32;

                    report.push(NixpkgsHammerMessage {
                        msg: "Please add a comment on the line above, explaining the purpose of this patch.".to_string(),
                        name: "missing-patch-comment",
                        locations: vec![SourceLocation::from_byte_index(files, file_id, start)?],
                        link: true,
                    });
                }
            }
        }
        None => {
            let start = kv.node().text_range().start().to_usize() as u32;

            report.push(NixpkgsHammerMessage {
                msg: "`patches` should be a list.".to_string(),
                name: "missing-patch-comment",
                locations: vec![SourceLocation::from_byte_index(files, file_id, start)?],
                link: true,
            });
        }
    };

    Ok(report)
}
