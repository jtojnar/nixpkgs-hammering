mod missing_patch_comment;
mod no_python_tests;
mod no_uri_literals;
mod stale_substitute;
mod unused_argument;

use std::error::Error;

pub use missing_patch_comment::run as missing_patch_comment;
pub use no_python_tests::run as no_python_tests;
pub use no_uri_literals::run as no_uri_literals;
pub use stale_substitute::run as stale_substitute;
pub use unused_argument::run as unused_argument;

use crate::common_structs::CheckedAttr;

pub type Check = fn(Vec<CheckedAttr>) -> Result<String, Box<dyn Error>>;

pub const ALL: [(&'static str, Check); 5] = [
    ("missing-patch-comment", missing_patch_comment),
    ("no-python-tests", no_python_tests),
    ("no-uri-literals", no_uri_literals),
    ("stale-substitute", stale_substitute),
    ("unused-argument", unused_argument),
];
