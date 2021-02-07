{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "no-license";

  src = ../fixtures/make;

  meta = with lib; {
  };
}
