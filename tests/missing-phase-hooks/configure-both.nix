{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-configure-both";

  src = ../fixtures/make;

  configurePhase = ''
    echo ./configure # just pretend
  '';
}
