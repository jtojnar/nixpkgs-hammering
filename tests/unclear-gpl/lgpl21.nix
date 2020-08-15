{ stdenv
}:

stdenv.mkDerivation {
  name = "unclear-gpl-lgpl21";

  src = ../fixtures/make;

  meta.license = [ stdenv.lib.licenses.lgpl21 ];
}
