{ stdenv
}:

stdenv.mkDerivation rec {
  name = "attribute-typo-insertion";

  src = ../fixtures/make;

  passthrough = [];
}
