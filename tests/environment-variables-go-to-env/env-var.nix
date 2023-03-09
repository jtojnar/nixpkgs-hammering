{
  stdenv,
}:

stdenv.mkDerivation rec {
  name = "environment-variables-go-to-env--env-var";

  src = ../fixtures/make;

  NIX_CFLAGS_COMPILE = "-lm";
}
