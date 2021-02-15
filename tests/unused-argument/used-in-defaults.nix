{ stdenv
, pkgs  # might look unused, but is not
, foobarbazqux ? pkgs.hello
}:

stdenv.mkDerivation {
  name = "used-pattern";

  src = ../fixtures/make;
  buildInputs = [ foobarbazqux ];
}
