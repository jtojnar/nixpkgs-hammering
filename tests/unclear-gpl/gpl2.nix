{ stdenv
}:

stdenv.mkDerivation {
  name = "unclear-gpl-gpl2";

  src = ../fixtures/make;

  meta.license = [ stdenv.lib.licenses.gpl2 ];
}
