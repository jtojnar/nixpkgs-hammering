{ stdenv
}:

stdenv.mkDerivation {
  name = "stale";

  src = ../fixtures/make;

  patchPhase = ''
    substituteInPlace foo.in --replace string-that-does-not-exist bar
  '';
}
