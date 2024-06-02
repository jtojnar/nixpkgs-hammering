mod missing_patch_comment;
mod no_uri_literals;
mod stale_substitute;
mod unused_argument;

pub use missing_patch_comment::run as missing_patch_comment;
pub use no_uri_literals::run as no_uri_literals;
pub use stale_substitute::run as stale_substitute;
pub use unused_argument::run as unused_argument;
