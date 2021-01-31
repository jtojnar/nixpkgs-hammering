{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "unclear-gpl-gpl1";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.gpl1 ];
}
