{ stdenv
, fetchpatch
, lib
}:

stdenv.mkDerivation {
  name = "ignore-nested-lists2";

  src = ../fixtures/make;

  patches = lib.optionals (true) [
    # comment here. no comment is required next to "foo" and "bar"
    (fetchpatch {
        url = "...";
        excludes = ["foo" "bar"];
    })
  ];
}
