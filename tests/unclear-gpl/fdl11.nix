{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "unclear-gpl-fdl11";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.fdl11 ];
}
