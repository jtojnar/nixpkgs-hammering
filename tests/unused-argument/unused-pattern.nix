{ stdenv
, unused
}:

stdenv.mkDerivation {
  name = "unused-pattern";

  src = ../fixtures/make;
}
