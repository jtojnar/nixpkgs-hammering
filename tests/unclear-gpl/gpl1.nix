{ stdenv
}:

stdenv.mkDerivation {
  name = "unclear-gpl-gpl1";

  src = ../fixtures/make;

  meta.license = [ stdenv.lib.licenses.gpl1 ];
}
