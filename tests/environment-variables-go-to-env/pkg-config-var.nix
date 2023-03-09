{
  stdenv,
}:

stdenv.mkDerivation rec {
  name = "environment-variables-go-to-env--pkg-config-var";

  src = ../fixtures/make;

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
}
