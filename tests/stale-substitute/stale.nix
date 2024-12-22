{ stdenv
}:

stdenv.mkDerivation {
  name = "stale";

  src = ../fixtures/make;

  patchPhase = ''
    substituteInPlace foo.in --replace-warn string-that-does-not-exist bar
  '';
}
