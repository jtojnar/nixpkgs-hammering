{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-build-post";

  src = ../fixtures/make;

  buildPhase = ''
    runHook preBuild
    make
  '';
}
