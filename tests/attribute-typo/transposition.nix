{ stdenv
}:

stdenv.mkDerivation rec {
  name = "attribute-typo-transposition";

  src = ../fixtures/make;

  propgaatedNativeBuildInptus = [];
}
