{ stdenv
, meson
, ninja
}:

stdenv.mkDerivation {
  name = "build-tools-in-build-inputs-meson";

  src = ../fixtures/meson;

  nativeBuildInputs = [
    ninja # Meson does not support make backend.
  ];

  buildInputs = [
    meson
  ];
}
