{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-build-both";

  src = ../fixtures/make;

  buildPhase = ''
    make
  '';
}
