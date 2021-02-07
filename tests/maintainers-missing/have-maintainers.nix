{ stdenv
, lib
}:

stdenv.mkDerivation {
  name = "have-maintainers";

  src = ../fixtures/make;

  meta = with lib; {
    maintainers = [ "foo" ];
  };
}
