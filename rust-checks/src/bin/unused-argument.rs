use rust_checks::{checks::unused_argument, common_structs::CheckedAttr};
use std::{error::Error, io};

fn main() -> Result<(), Box<dyn Error>> {
    let attrs: Vec<CheckedAttr> = serde_json::from_reader(io::stdin())?;
    println!("{}", unused_argument(attrs)?);
    Ok(())
}
