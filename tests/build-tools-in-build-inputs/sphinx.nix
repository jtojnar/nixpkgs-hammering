{ stdenv
, python3
}:

stdenv.mkDerivation {
  name = "build-tools-in-build-inputs-sphinx";

  src = ../fixtures/make;

  buildInputs = [
    python3.pkgs.sphinx
  ];
}
