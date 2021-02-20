{ stdenv
}:

let
  function = used: used + used;
in
  stdenv.mkDerivation {
    name = "unused-single";

    src = ../fixtures/make;
  }
