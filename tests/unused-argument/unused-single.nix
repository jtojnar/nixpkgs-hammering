{ stdenv
}:

let
  function = unused: 1;
in
  stdenv.mkDerivation {
    name = "unused-single";

    src = ../fixtures/make;
  }
