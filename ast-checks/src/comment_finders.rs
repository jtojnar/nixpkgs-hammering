use crate::tree_utils::{next_siblings, prev_siblings, walk_kind};
use rnix::{NodeOrToken, SyntaxElement, SyntaxKind::*, SyntaxNode};

pub fn find_comment_within(node: &SyntaxNode) -> Option<String> {
    // Find the first `TOKEN_COMMENT` within.
    let tok = walk_kind(node, TOKEN_COMMENT).next()?;
    // Iterate over sibling comments and concatenate them.
    let node_iter = next_siblings(&tok);
    let doc = collect_comment_text(node_iter);
    Some(doc).filter(|it| !it.is_empty())
}

pub fn find_comment_above(node: &SyntaxNode) -> Option<String> {
    // Note: The `prev_siblings` iterator includes self, which
    // is not a `TOKEN_COMMENT`, so we need to skip one.
    let node_iter = prev_siblings(&NodeOrToken::Node(node.clone())).skip(1);
    let doc = collect_comment_text(node_iter);
    Some(doc).filter(|it| !it.is_empty())
}

fn collect_comment_text(node_iter: impl Iterator<Item = SyntaxElement>) -> String {
    // Take text of all immediately subsequent `TOKEN_COMMENT`s,
    // skipping over whitespace-only tokens.
    // Note this would be more clearly written using `map_while`, but that
    // does not seem to be in Rust stable yet.
    node_iter
        .filter_map(|node| node.into_token())
        .take_while(|tok| tok.kind() == TOKEN_COMMENT || tok.kind().is_trivia())
        .map(|tok| tok.text().to_string())
        .map(|s| s.trim_start_matches('#').trim().to_string())
        .filter(|s| !s.is_empty())
        .collect::<Vec<_>>()
        .join("\n")
}
