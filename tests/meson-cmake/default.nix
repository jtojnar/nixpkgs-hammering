{ stdenv
, meson
, cmake
, ninja
}:

stdenv.mkDerivation {
  name = "meson-cmake";

  src = ../fixtures/meson;

  nativeBuildInputs = [
    meson
    cmake
    ninja # Meson does not support make backend.
  ];
}
