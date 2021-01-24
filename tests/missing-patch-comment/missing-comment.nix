{ stdenv
}:

stdenv.mkDerivation {
  name = "missing-comment";

  src = ../fixtures/make;

  patches = [
    "a"
    "b"
    "c"
  ];
}
