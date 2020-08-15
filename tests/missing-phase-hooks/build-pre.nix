{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-build-pre";

  src = ../fixtures/make;

  buildPhase = ''
    make
    runHook postBuild
  '';
}
