use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct SourceLocation {
    pub column: usize,
    pub line: usize,
    pub file: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct NixpkgsHammerMessage {
    pub cond: bool,
    pub locations: Vec<SourceLocation>,
    pub msg: &'static str,
    pub name: &'static str,
}
