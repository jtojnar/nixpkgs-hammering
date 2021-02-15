{ stdenv
}:

stdenv.mkDerivation rec {
  pname = "exception";
  version = "0";

  src = ../fixtures/make;

  propagatedBuildInputs = [ (builtins.throw "Throw an exception") ];
}
