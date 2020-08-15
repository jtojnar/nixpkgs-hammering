{ stdenv
}:

stdenv.mkDerivation {
  name = "explicit-phases-install";

  src = ../fixtures/make;

  installPhase = ''
    runHook preInstall
    make install
    runHook postInstall
  '';
}
