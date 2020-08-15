{ stdenv
}:

stdenv.mkDerivation {
  name = "unclear-gpl-lgpl2";

  src = ../fixtures/make;

  meta.license = [ stdenv.lib.licenses.lgpl2 ];
}
