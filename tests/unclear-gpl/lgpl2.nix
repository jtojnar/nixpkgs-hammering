{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "unclear-gpl-lgpl2";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.lgpl2 ];
}
