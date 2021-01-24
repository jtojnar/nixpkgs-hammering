{ stdenv
}:

stdenv.mkDerivation {
  name = "comment-above";

  src = ../fixtures/make;

  patches = [
    # comment for a
    "a"
    # comment for b
    "b"
    # comment for c
    "c"
  ];
}
