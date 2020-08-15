{ stdenv
}:

stdenv.mkDerivation {
  name = "unclear-gpl-lgpl3";

  src = ../fixtures/make;

  meta.license = [ stdenv.lib.licenses.lgpl3 ];
}
