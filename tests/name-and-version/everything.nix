{ stdenv, lib }:

stdenv.mkDerivation rec {
  name = "${pname}-${variant}-${version}";
  pname = "name-and-version";
  variant = "frobnicated";
  version = "1.0";

  src = ../fixtures/make;
}
