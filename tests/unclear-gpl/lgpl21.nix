{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "unclear-gpl-lgpl21";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.lgpl21 ];
}
