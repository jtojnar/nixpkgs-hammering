use rust_checks::common_structs;
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

fn pb_to_string(buf: PathBuf) -> Result<String, String> {
    Ok(buf
        .to_str()
        .ok_or_else(|| format!("File path ‘{}’ not a valid UTF-8 string", buf.display()))?
        .to_owned())
}

impl TryInto<common_structs::SourceLocation> for SourceLocation {
    type Error = String;

    fn try_into(self) -> Result<common_structs::SourceLocation, Self::Error> {
        let SourceLocation { file, line, column } = self;
        Ok(common_structs::SourceLocation {
            file: pb_to_string(file)?,
            line,
            column,
        })
    }
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

impl TryInto<common_structs::CheckedAttr> for CheckedAttr {
    type Error = String;

    fn try_into(self) -> Result<common_structs::CheckedAttr, Self::Error> {
        let CheckedAttr {
            name,
            location,
            drv,
            output,
        } = self;

        let location = location.map(|l| l.try_into()).transpose()?;
        let drv = drv.map(pb_to_string).transpose()?;
        let output = output.map(pb_to_string).transpose()?;

        Ok(common_structs::CheckedAttr {
            name,
            location,
            drv,
            output,
        })
    }
}
