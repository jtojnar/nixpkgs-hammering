{ stdenv
, foo
}:

stdenv.mkDerivation {
  name = "used-in-string2";

  src = ../fixtures/make;
  key = ''  '${foo}'  '';
}
