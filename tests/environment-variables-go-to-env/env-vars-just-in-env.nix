{
  stdenv,
}:

stdenv.mkDerivation rec {
  name = "environment-variables-go-to-env--env-vars-just-in-env";

  src = ../fixtures/make;

  env = {
    NIX_CFLAGS_COMPILE = "-lm";
  };
}
