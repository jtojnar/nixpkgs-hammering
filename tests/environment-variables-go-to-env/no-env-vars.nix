{
  stdenv,
}:

stdenv.mkDerivation rec {
  name = "environment-variables-go-to-env--no-env-vars";

  src = ../fixtures/make;

  nativeBuildInputs = [];
}
