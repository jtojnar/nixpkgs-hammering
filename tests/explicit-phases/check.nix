{ stdenv
}:

stdenv.mkDerivation {
  name = "explicit-phases-check";

  src = ../fixtures/make;

  checkPhase = ''
    make check
    runHook postCheck
  '';
}
