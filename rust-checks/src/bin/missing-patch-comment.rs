use codespan::{FileId, Files};
use nixpkgs_hammering_ast_checks::{
    analysis::*,
    comment_finders::{find_comment_above, find_comment_after, find_comment_within},
    common_structs::{CheckedAttr, NixpkgsHammerMessage, SourceLocation},
    tree_utils::{parents, walk_attrpath_values_filter_attrpath, walk_kind},
};
use rnix::{ast::*, SyntaxKind::*};
use rowan::ast::AstNode as _;
use std::{error::Error, io};

fn main() -> Result<(), Box<dyn Error>> {
    let attrs: Vec<CheckedAttr> = serde_json::from_reader(io::stdin())?;
    println!("{}", analyze_nix_files(attrs, analyze_single_file)?);
    Ok(())
}

fn analyze_single_file(files: &Files<String>, file_id: FileId) -> Result<Report, Box<dyn Error>> {
    let root = find_root(files, file_id)?;
    let mut report: Report = vec![];

    // Find all “patches” attrset attributes, that
    // *do not* have a comment directly above them.
    let patches_without_top_comment = walk_attrpath_values_filter_attrpath(&root, "patches")
        .filter(|pair| {
            // Look for a comment directly above the `patches = …` line
            // (Interpreting that as a comment which applies to all patches.)
            find_comment_above(pair.syntax()).is_none()
        });

    // For each list of patches without a top comment,
    // produce a report for each patch that is missing a per-patch comment.
    for pair in patches_without_top_comment {
        let value = pair
            .value()
            .ok_or("Internal logic error: Unable to extract value from key/value pair")?;
        let contained_nonnested_lists = walk_kind(&value.syntax(), NODE_LIST).filter(|elem| {
            // As we’re walking down the tree looking for list nodes under `pair`, we don’t
            // want to walk too deep. We’re looking for lists, but we don’t want to find
            // any lists that are inside other lists, since those are likely not patches
            // (they’re probably arguments to `fetchpatch` like `excludes`)

            // So we’ll filter the lists returned by walk_kind (which is doing a full
            // tree traversal) by counting the number of lists that occur between this
            // node `elem` and `pair`, and checking for there to be only 1.

            // N.b.: there’s a more efficient way to do this, but it wouldn’t allow us
            // to re-use walk_kind and implementing our own tree traversal in rust is not
            // worth it -- speed is not an issue
            parents(elem.clone().into_node().unwrap())
                .take_while(|elem| elem.text_range() != pair.syntax().text_range())
                .filter(|elem| elem.kind() == NODE_LIST)
                .count()
                == 1
        });
        for elem in contained_nonnested_lists {
            let patch_list = List::cast(elem.into_node().ok_or(
                "Internal logic error: Unable to cast element with kind NODE_LIST to into a Node",
            )?)
            .ok_or(
                "Internal logic error: Unable to cast from a node with kind NODE_LIST to a List",
            )?;
            report.extend(process_patch_list(patch_list, files, file_id)?);
        }
    }

    Ok(report)
}

fn process_patch_list(
    patchlist: List,
    files: &Files<String>,
    file_id: FileId,
) -> Result<Report, Box<dyn Error>> {
    let mut report: Report = vec![];

    // For each element in the list of patches, look for
    // a comment directly above the element or, if we don’t see
    // one of those, look for a comment within AST of the element.
    for item in patchlist.items() {
        let item = item.syntax();
        let has_comment_above = find_comment_above(&item).is_some();
        let has_comment_within = find_comment_within(&item).is_some();
        let has_comment_after = find_comment_after(&item).is_some();
        let has_comment = has_comment_above || has_comment_within || has_comment_after;

        if !has_comment {
            let start: u32 = item.text_range().start().into();

            report.push(NixpkgsHammerMessage {
                msg:
                    "Consider adding a comment explaining the purpose of this patch on the line preceeding."
                        .to_string(),
                name: "missing-patch-comment",
                locations: vec![SourceLocation::from_byte_index(files, file_id, start)?],
                link: true,
            });
        }
    }

    Ok(report)
}
