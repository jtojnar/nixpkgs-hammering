{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-configure-pre";

  src = ../fixtures/make;

  configurePhase = ''
    echo ./configure # just pretend
    runHook postConfigure
  '';
}
