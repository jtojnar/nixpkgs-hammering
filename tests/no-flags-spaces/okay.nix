{ stdenv
}:

stdenv.mkDerivation {
  name = "no-flags-spaces-okay";

  src = ../fixtures/make;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LIBDIR=${placeholder "out"}/lib"
  ];
}
