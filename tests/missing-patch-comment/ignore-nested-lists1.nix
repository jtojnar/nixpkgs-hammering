{ stdenv
, fetchpatch
}:

stdenv.mkDerivation {
  name = "ignore-nested-lists";

  src = ../fixtures/make;

  patches = [
    # comment here. no comment is required next to "foo" and "bar"
    (fetchpatch {
        url = "...";
        excludes = ["foo" "bar"];
    })
  ];
}
