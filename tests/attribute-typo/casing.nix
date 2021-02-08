{ stdenv
}:

stdenv.mkDerivation rec {
  name = "attribute-typo-casing";

  src = ../fixtures/make;

  postfixup = ''
    blah
  '';
}
