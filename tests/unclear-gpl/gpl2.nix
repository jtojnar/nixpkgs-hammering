{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "unclear-gpl-gpl2";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.gpl2 ];
}
