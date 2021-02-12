{ stdenv
}:

stdenv.mkDerivation rec {
  name = "attribute-typo-unknown-short";

  src = ../fixtures/make;

  wrc = true;
}
