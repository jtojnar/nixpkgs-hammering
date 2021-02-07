{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "have-license";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.mit ];
}
