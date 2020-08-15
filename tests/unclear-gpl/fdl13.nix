{ stdenv
}:

stdenv.mkDerivation {
  name = "unclear-gpl-fdl13";

  src = ../fixtures/make;

  meta.license = [ stdenv.lib.licenses.fdl13 ];
}
