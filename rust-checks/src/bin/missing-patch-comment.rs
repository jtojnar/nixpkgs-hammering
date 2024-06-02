use nixpkgs_hammering_ast_checks::{checks::missing_patch_comment, common_structs::CheckedAttr};
use std::{error::Error, io};

fn main() -> Result<(), Box<dyn Error>> {
    let attrs: Vec<CheckedAttr> = serde_json::from_reader(io::stdin())?;
    println!("{}", missing_patch_comment(attrs)?);
    Ok(())
}
