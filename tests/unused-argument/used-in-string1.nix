{ stdenv
, foo
}:

stdenv.mkDerivation {
  name = "used-in-string";

  src = ../fixtures/make;
  key = "${foo}";
}
