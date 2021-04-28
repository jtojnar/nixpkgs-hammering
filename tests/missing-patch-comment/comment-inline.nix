{ stdenv
}:

stdenv.mkDerivation {
  name = "comment-inline";

  src = ../fixtures/make;

  patches = [
    "a"  # comment for a
    "b"  # comment for b
    "c"  # comment for c
  ];
}
