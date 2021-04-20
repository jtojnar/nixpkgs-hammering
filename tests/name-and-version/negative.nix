{ stdenv, lib }:

stdenv.mkDerivation {
  pname = "name-and-version";
  version = "1.0";

  src = ../fixtures/make;
}
