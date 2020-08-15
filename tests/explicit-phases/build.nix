{ stdenv
}:

stdenv.mkDerivation {
  name = "explicit-phases-build";

  src = ../fixtures/make;

  buildPhase = ''
    make
    runHook postBuild
  '';
}
