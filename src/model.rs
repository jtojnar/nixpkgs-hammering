use serde::{Deserialize, Serialize};
use std::{fmt::Display, path::PathBuf};

#[derive(Debug, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub enum Severity {
    Error,
    Warning,
    Notice,
}
impl Display for Severity {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Severity::Error => write!(f, "error"),
            Severity::Warning => write!(f, "warning"),
            Severity::Notice => write!(f, "notice"),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize, Hash)]
pub struct SourceLocation {
    pub file: PathBuf,
    pub line: usize,
    pub column: Option<usize>,
}

fn default_link() -> bool {
    true
}

fn default_severity() -> Severity {
    Severity::Warning
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Report {
    pub name: String,
    pub msg: String,
    #[serde(default)]
    pub locations: Vec<SourceLocation>,
    #[serde(default = "default_link")]
    pub link: bool,
    #[serde(default = "default_severity")]
    pub severity: Severity,
}

#[derive(Debug, Clone, PartialEq, Serialize, Eq, Hash)]
pub struct CheckedAttr {
    /// name of attr, e.g. python38Packages.numpy
    pub name: String,
    /// location in which the attr is defined, if exist
    pub location: Option<SourceLocation>,
    /// path to the .drv file, if exists
    pub drv: Option<PathBuf>,
    /// path the the output of the drv in the nix store, if exists
    pub output: Option<PathBuf>,
}
