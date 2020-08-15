{ stdenv
}:

stdenv.mkDerivation {
  name = "unclear-gpl-fdl12";

  src = ../fixtures/make;

  meta.license = [ stdenv.lib.licenses.fdl12 ];
}
