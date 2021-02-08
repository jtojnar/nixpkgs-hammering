use codespan::{FileId, Files};
use nixpkgs_hammering_ast_checks::comment_finders::{find_comment_above, find_comment_within};
use nixpkgs_hammering_ast_checks::common_structs::{NixpkgsHammerMessage, SourceLocation};
use rnix::types::*;
use std::{collections::HashMap, env, error::Error, fs};
use nixpkgs_hammering_ast_checks::tree_utils::walk_keyvalues_filter_key;

fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<String> = env::args().skip(1).collect();
    let mut report = HashMap::new();

    let mut files = Files::new();
    for filename in args {
        let file_id = files.add(filename.clone(), fs::read_to_string(&filename)?);
        report.insert(filename.clone(), analyze_single_file(&files, file_id)?);
    }

    println!("{}", serde_json::to_string(&report)?);
    Ok(())
}

fn analyze_single_file(
    files: &Files<String>,
    file_id: FileId,
) -> Result<Vec<NixpkgsHammerMessage>, Box<dyn Error>> {
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
    let root = ast.root().inner().ok_or(format!(
        "No elements in the AST in path {}",
        files
            .name(file_id)
            .to_str()
            .unwrap_or("unprintable file, encoding error")
    ))?;
    let mut report: Vec<NixpkgsHammerMessage> = vec![];

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
) -> Result<Vec<NixpkgsHammerMessage>, Box<dyn Error>> {
    let mut report: Vec<NixpkgsHammerMessage> = vec![];

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
                    let loc = files.location(file_id, start)?;

                    report.push(NixpkgsHammerMessage {
                    cond: true,
                    msg: "Please add a comment on the line above, explaining the purpose of this patch.",
                    name: "missing-patch-comment",
                    locations: vec![SourceLocation {
                        file: files
                            .name(file_id)
                            .to_str()
                            .ok_or("encoding error")?
                            .to_string(),
                        // Convert 0-based indexing to 1-based.
                        column: loc.column.to_usize() + 1,
                        line: loc.line.to_usize() + 1,
                    }],
                });
                }
            }
        }
        None => {
            let start = kv.node().text_range().start().to_usize() as u32;
            let loc = files.location(file_id, start)?;

            report.push(NixpkgsHammerMessage {
                cond: true,
                msg: "`patches` should be a list.",
                name: "missing-patch-comment",
                locations: vec![SourceLocation {
                    file: files
                        .name(file_id)
                        .to_str()
                        .ok_or("encoding error")?
                        .to_string(),
                    // Convert 0-based indexing to 1-based.
                    column: loc.column.to_usize() + 1,
                    line: loc.line.to_usize() + 1,
                }],
            });
        }
    };

    Ok(report)
}
