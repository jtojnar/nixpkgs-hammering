{ stdenv
, meson
, ninja
}:

stdenv.mkDerivation {
  name = "build-tools-in-build-inputs-ninja";

  src = ../fixtures/meson; # Writing ninja rules by hand is intentionally painful.

  nativeBuildInputs = [
    meson
  ];

  buildInputs = [
    ninja
  ];
}
