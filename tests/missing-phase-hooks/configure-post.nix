{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-configure-post";

  src = ../fixtures/make;

  configurePhase = ''
    runHook preConfigure
    echo ./configure # just pretend
  '';
}
