{ stdenv
, lib
, fetchurl
}:

stdenv.mkDerivation rec {
  meta = with lib; {
    description = "";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [];
  };

  passthru = { };

  nativeBuildInputs = [];

  patches = [];

  src = ../fixtures/make;

  version = "0.0.0";

  pname = "out-of-order";
}
