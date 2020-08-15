{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-check-both";

  src = ../fixtures/make;

  checkPhase = ''
    make check
  '';
}
