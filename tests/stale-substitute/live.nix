{ stdenv
}:

stdenv.mkDerivation {
  name = "live";

  src = ../fixtures/make;

  patchPhase = ''
    substituteInPlace foo.in --replace foo bar
  '';
}
