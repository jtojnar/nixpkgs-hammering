{ stdenv
}:

stdenv.mkDerivation {
  name = "unused-single";

  src = ../fixtures/make;
  function = used: used + used;
}
