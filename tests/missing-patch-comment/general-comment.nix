{ stdenv
}:

stdenv.mkDerivation {
  name = "general-comment";

  src = ../fixtures/make;

  # global comment
  patches = [
    "a"
    "b"
    "c"
  ];
}
