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
        url = ../fixtures/patch.patch;
        sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
        excludes = ["foo" "bar"];
    })
  ];
}
