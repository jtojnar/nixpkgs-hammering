{ stdenv
}:

stdenv.mkDerivation {
  name = "explicit-phases-configure";

  src = ../fixtures/make;

  configurePhase = ''
    echo ./configure # just pretend
    runHook postConfigure
  '';
}
