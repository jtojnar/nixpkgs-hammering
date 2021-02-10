use codespan::{ByteIndex, FileId, Files};
use serde::{Deserialize, Serialize};
use std::error::Error;

#[derive(Serialize, Deserialize, Debug)]
pub struct SourceLocation {
    pub column: usize,
    pub line: usize,
    pub file: String,
}

impl SourceLocation {
    pub fn from_byte_index(
        files: &Files<String>,
        file_id: FileId,
        byte_index: impl Into<ByteIndex>,
    ) -> Result<SourceLocation, Box<dyn Error>> {
        let loc = files.location(file_id, byte_index)?;

        Ok(SourceLocation {
            file: files
                .name(file_id)
                .to_str()
                .ok_or("encoding error")?
                .to_string(),
            // Convert 0-based indexing to 1-based.
            column: loc.column.to_usize() + 1,
            line: loc.line.to_usize() + 1,
        })
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub struct NixpkgsHammerMessage {
    pub locations: Vec<SourceLocation>,
    pub msg: String,
    pub name: &'static str,
    pub link: bool,
}
