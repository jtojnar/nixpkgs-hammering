{ stdenv
}:

stdenv.mkDerivation {
  name = "nonstring";

  src = ../fixtures/make;

  configureFlags = [ "--foo" [ "--bar" ] ];
}
