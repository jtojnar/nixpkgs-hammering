{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "unclear-gpl-single-nonmatching-license";

  src = ../fixtures/make;

  meta.license = lib.licenses.asl20;
}
