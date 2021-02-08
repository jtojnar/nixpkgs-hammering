{ stdenv
}:

stdenv.mkDerivation {
  name = "no-flags-spaces-bad";

  src = ../fixtures/make;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LIBDIR=${placeholder "out"}/lib"
    "RELEASE=August 2020"
  ];
}
