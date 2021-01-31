{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "unclear-gpl-fdl13";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.fdl13 ];
}
