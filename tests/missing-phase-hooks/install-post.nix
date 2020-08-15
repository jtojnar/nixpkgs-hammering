{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-install-post";

  src = ../fixtures/make;

  installPhase = ''
    runHook preInstall
    make install
  '';
}
