{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "empty-maintainers";

  src = ../fixtures/make;

  meta = with lib; {
    maintainers = [];
  };
}
