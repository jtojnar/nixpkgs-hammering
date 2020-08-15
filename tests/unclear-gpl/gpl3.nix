{ stdenv
}:

stdenv.mkDerivation {
  name = "unclear-gpl-gpl3";

  src = ../fixtures/make;

  meta.license = [ stdenv.lib.licenses.gpl3 ];
}
