{ stdenv
}:

stdenv.mkDerivation rec {
  pname = "no-exception";
  version = "0";

  src = ../fixtures/make;

  propagatedBuildInputs = [ ];
}
