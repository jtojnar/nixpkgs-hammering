{ stdenv, lib }:

stdenv.mkDerivation {
  name = "name-and-version";
  version = "1.0";

  src = ../fixtures/make;
}
