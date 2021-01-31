{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "unclear-gpl-lgpl3";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.lgpl3 ];
}
