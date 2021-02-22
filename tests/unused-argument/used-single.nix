{ stdenv
}:

stdenv.mkDerivation {
  name = "unused-single";

  src = ../fixtures/make;

  passthru = {
     function = used: used + used;
  };
}
