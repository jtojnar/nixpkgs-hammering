{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-install-pre";

  src = ../fixtures/make;

  installPhase = ''
    make install
    runHook postInstall
  '';
}
