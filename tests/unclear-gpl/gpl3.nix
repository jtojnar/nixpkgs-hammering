{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "unclear-gpl-gpl3";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.gpl3 ];
}
