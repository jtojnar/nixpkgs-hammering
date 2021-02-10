use codespan::{FileId, Files};
use nixpkgs_hammering_ast_checks::analysis::*;
use nixpkgs_hammering_ast_checks::common_structs::*;
use nixpkgs_hammering_ast_checks::tree_utils::walk_kind;
use rnix::{types::*, SyntaxNode};
use rnix::SyntaxKind::*;
use std::{env, error::Error};

fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<String> = env::args().skip(1).collect();
    println!("{}", analyze_files(args, analyze_single_file)?);
    Ok(())
}

fn analyze_single_file(files: &Files<String>, file_id: FileId) -> Result<Report, Box<dyn Error>> {
    let root = find_root(files, file_id)?;
    let mut report: Report = vec![];

    // This check looks for unused variables by walking the AST. It has a very
    // simple implementation: for each function that takes its arguments using
    // a pattern contract, we record the names of the variables. Then, we walk through
    // the body of the function and look for those names being used as identifiers. If
    // we don't see them, we call it an unused variable.

    // This design is simple and I don't believe that it produces any false positives,
    // which would be highly undesirable. It does, however, produce some false negatives.
    // Because we're not tracking all the intermediate scopes between the declaration of the
    // formal parameter and its use in the function body, it's possible for inner functions,
    // with statements, or let blocks that cause variables in the outer scope to be shadowed
    // to make this check _think_ that a variable is used when it really wasn't.

    // Fixing this behavior could be done by following the pseudocode in
    // https://github.com/jtojnar/nixpkgs-hammering/pull/32#issuecomment-776936922
    // but hasn't been done yet because we don't think rare false negatives are a high
    // priority.

    for lambda_elem in walk_kind(&root, NODE_LAMBDA) {
        let lambda = lambda_elem.into_node().and_then(Lambda::cast);

        let body = lambda
            .clone()
            .and_then(|l| l.body())
            .ok_or("Unable to extract function body")?;
        let identifiers_in_body: Vec<Ident> = walk_kind(&body, NODE_IDENT)
            .filter_map(|elem| elem.into_node())
            .filter_map(Ident::cast)
            // Filter out identifiers that are acting as keys in an attrset
            // i.e a construct like ```{
            //   x = 1;
            // }```
            // does not mean that `x` is acting as a usage of the identifier
            // `x` for purposes of detecting unused variables
            .filter(|ident| !ident_is_attrset_key(ident.node()))
            .collect();

        // Extract the formal parameters from pattern-type functions, and don't
        // extract anything from single-argument functions because they often
        // need to have unused arguments for overlay-type constructs.
        let pattern = lambda.and_then(|l| l.arg()).and_then(Pattern::cast);
        let formal_parameter_pattern_args = match pattern {
            Some(pattern) => pattern.entries().filter_map(|entry| entry.name()).collect(),
            None => vec![],
        };

        let unused_formal_parameters = formal_parameter_pattern_args
            .iter()
            // Filter out formal parameters that are used as identifiers
            // in the function body
            .filter(|formal| {
                !identifiers_in_body
                    .iter()
                    .any(|ident| ident.as_str() == formal.as_str())
            });

        for unused in unused_formal_parameters {
            let start = unused.node().text_range().start().to_usize() as u32;
            report.push(NixpkgsHammerMessage {
                msg: format!("Unused argument: `{}`.", unused.node()),
                name: "unused-argument",
                locations: vec![SourceLocation::from_byte_index(files, file_id, start)?],
                link: false,
            });
        }
    }

    Ok(report)
}

fn ident_is_attrset_key(node: &SyntaxNode) -> bool {
    match node.parent() {
        Some(p) if p.kind() == NODE_KEY => true,
        _ => false
    }
}
