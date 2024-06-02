use rust_checks::{checks::stale_substitute, common_structs::CheckedAttr};
use std::{error::Error, io};

fn main() -> Result<(), Box<dyn Error>> {
    let attrs: Vec<CheckedAttr> = serde_json::from_reader(io::stdin())?;
    println!("{}", stale_substitute(attrs)?);
    Ok(())
}
