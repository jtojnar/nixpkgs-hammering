{ stdenv
, var1
, var2
}:

stdenv.mkDerivation {
  name = "used-pattern";

  src = ../fixtures/make;
  argument = {
    inherit var1 var2;
  };
}
