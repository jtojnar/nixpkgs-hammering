{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-check-post";

  src = ../fixtures/make;

  checkPhase = ''
    runHook preCheck
    make check
  '';
}
