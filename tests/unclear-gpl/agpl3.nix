{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "unclear-gpl-agpl3";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.agpl3 ];
}
