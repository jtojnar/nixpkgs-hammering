{ stdenv
, qt5
}:

stdenv.mkDerivation {
  name = "unnecessary-parallel-building-qmake";

  src = ../fixtures/qmake;

  nativeBuildInputs = [
    qt5.qmake
  ];

  enableParallelBuilding = true;
}
