{ stdenv
, cmake
}:

stdenv.mkDerivation {
  name = "build-tools-in-build-inputs-cmake";

  src = ../fixtures/cmake;

  buildInputs = [
    cmake
  ];
}
