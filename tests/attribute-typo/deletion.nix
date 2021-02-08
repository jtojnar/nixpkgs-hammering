{ stdenv
}:

stdenv.mkDerivation rec {
  name = "attribute-typo-deletion";

  src = ../fixtures/make;

  configurFlags = [];
}
