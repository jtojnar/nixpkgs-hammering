{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "no-maintainers";

  src = ../fixtures/make;

  meta = with lib; {
  };
}
