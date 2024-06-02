use crate::common_structs::CheckedAttr;
use std::error::Error;

mod missing_patch_comment;
mod no_uri_literals;
mod stale_substitute;
mod unused_argument;

pub use missing_patch_comment::run as missing_patch_comment;
pub use no_uri_literals::run as no_uri_literals;
pub use stale_substitute::run as stale_substitute;
pub use unused_argument::run as unused_argument;

pub type Check = fn(Vec<CheckedAttr>) -> Result<String, Box<dyn Error>>;

pub const ALL: [(&'static str, Check); 4] = [
    ("missing-patch-comment", missing_patch_comment),
    ("no-uri-literals", no_uri_literals),
    ("stale-substitute", stale_substitute),
    ("unused-argument", unused_argument),
];
