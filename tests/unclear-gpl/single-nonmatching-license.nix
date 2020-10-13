{ stdenv
}:

stdenv.mkDerivation {
  name = "unclear-gpl-single-nonmatching-license";

  src = ../fixtures/make;

  meta.license = stdenv.lib.licenses.asl20;
}
