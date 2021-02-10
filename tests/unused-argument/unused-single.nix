{ stdenv
}:

stdenv.mkDerivation {
  name = "unused-single";

  src = ../fixtures/make;
  function = unused: 1;
}
