{ stdenv
}:

let
  pname = "attribute-ordering-inherited";
  version = "0.0.0";
  src = ../fixtures/make;
in
stdenv.mkDerivation rec {
  inherit pname version src;
}
