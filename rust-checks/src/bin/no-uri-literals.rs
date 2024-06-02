use nixpkgs_hammering_ast_checks::{checks::no_uri_literals, common_structs::CheckedAttr};
use std::{error::Error, io};

fn main() -> Result<(), Box<dyn Error>> {
    let attrs: Vec<CheckedAttr> = serde_json::from_reader(io::stdin())?;
    println!("{}", no_uri_literals(attrs)?);
    Ok(())
}
