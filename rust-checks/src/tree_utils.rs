use rnix::{types::*, SyntaxElement, SyntaxKind, SyntaxKind::*, SyntaxNode, WalkEvent};
use std::iter::{once, successors};

pub fn walk_kind(node: &SyntaxNode, kind: SyntaxKind) -> impl Iterator<Item = SyntaxElement> {
    // Iterates over all AST nodes under `node` with the specified `kind`.
    node.preorder_with_tokens()
        .filter_map(move |event| match event {
            WalkEvent::Enter(element) => Some(element).filter(|it| it.kind() == kind),
            WalkEvent::Leave(_) => None,
        })
}

pub fn walk_keyvalues_filter_key<'a>(
    node: &SyntaxNode,
    key: &'a str,
) -> impl Iterator<Item = KeyValue> + 'a {
    // Iterates over all AST nodes under `node` that are of kind `NODE_KEY_VALUE`,
    // (which corresponds to a key-value pair inside a nix attrset) and yields
    // only the nodes where the key is equal to `key`.
    walk_kind(node, NODE_KEY_VALUE)
        .filter_map(|element| element.into_node())
        .filter_map(|node| KeyValue::cast(node))
        .filter(move |kv| {
            kv.key()
                .map_or(false, |e| e.node().to_string() == key.to_string())
        })
}

pub fn next_siblings(element: &SyntaxElement) -> impl Iterator<Item = SyntaxElement> {
    // Iterates over both `element` and its sibling elements that come after it in the AST.
    once(element.clone()).chain(successors(element.next_sibling_or_token(), |it| {
        it.next_sibling_or_token()
    }))
}

pub fn prev_siblings(element: &SyntaxElement) -> impl Iterator<Item = SyntaxElement> {
    // Iterate over both `element` and its sibling elements that come before it in the AST.
    once(element.clone()).chain(successors(element.prev_sibling_or_token(), |it| {
        it.prev_sibling_or_token()
    }))
}

pub fn parents(node: SyntaxNode) -> impl Iterator<Item = SyntaxNode> {
    std::iter::successors(Some(node), |node| node.parent())
}
