{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "empty-license";

  src = ../fixtures/make;

  meta = with lib; {
    license = [];
  };
}
