{ stdenv
, cmake
}:

stdenv.mkDerivation {
  name = "unnecessary-parallel-building-cmake";

  src = ../fixtures/cmake;

  nativeBuildInputs = [
    cmake
  ];

  enableParallelBuilding = true;
}
