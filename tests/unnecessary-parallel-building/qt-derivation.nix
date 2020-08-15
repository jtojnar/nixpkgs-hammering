{ mkDerivation
, qmake
}:

mkDerivation {
  name = "unnecessary-parallel-building-qt-derivation";

  src = ../fixtures/qmake;

  nativeBuildInputs = [
    qmake
  ];

  enableParallelBuilding = true;
}
