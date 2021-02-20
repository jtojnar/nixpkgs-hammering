{ stdenv
, var1
, var2
}:

let
  argument = {
    inherit var1 var2;
  };
in
  stdenv.mkDerivation {
    name = "used-pattern";

    src = ../fixtures/make;
  }
