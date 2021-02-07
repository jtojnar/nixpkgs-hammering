{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "no-meta";

  src = ../fixtures/make;
}
