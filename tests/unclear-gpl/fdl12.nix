{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "unclear-gpl-fdl12";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.fdl12 ];
}
