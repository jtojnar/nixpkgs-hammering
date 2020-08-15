{ stdenv
}:

stdenv.mkDerivation {
  name = "unclear-gpl-fdl11";

  src = ../fixtures/make;

  meta.license = [ stdenv.lib.licenses.fdl11 ];
}
