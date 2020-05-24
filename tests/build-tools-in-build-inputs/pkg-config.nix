{ stdenv
, pkg-config
}:

stdenv.mkDerivation {
  name = "build-tools-in-build-inputs-pkg-config";

  src = ../fixtures/make;

  buildInputs = [
    pkg-config
  ];
}
