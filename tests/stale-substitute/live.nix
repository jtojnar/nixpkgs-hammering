{ stdenv
}:

stdenv.mkDerivation {
  name = "live";

  src = ../fixtures/make;

  patchPhase = ''
    substituteInPlace foo.in --replace-warn foo bar
  '';
}
