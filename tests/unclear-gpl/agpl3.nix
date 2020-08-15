{ stdenv
}:

stdenv.mkDerivation {
  name = "unclear-gpl-agpl3";

  src = ../fixtures/make;

  meta.license = [ stdenv.lib.licenses.agpl3 ];
}
