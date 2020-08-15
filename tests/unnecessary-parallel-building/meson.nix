{ stdenv
, meson
, ninja
}:

stdenv.mkDerivation {
  name = "unnecessary-parallel-building-meson";

  src = ../fixtures/meson;

  nativeBuildInputs = [
    meson
    ninja # Meson does not support make backend.
  ];

  enableParallelBuilding = true;
}
