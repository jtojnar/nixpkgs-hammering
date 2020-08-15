{ stdenv
}:

stdenv.mkDerivation {
  name = "phase-hooks-install-both";

  src = ../fixtures/make;

  installPhase = ''
    make install
  '';
}
