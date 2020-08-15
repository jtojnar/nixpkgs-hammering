{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-check-pre";

  src = ../fixtures/make;

  checkPhase = ''
    make check
    runHook postCheck
  '';
}
