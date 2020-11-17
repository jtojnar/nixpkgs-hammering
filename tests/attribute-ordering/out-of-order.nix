{ stdenv 
, fetchurl
}:

stdenv.mkDerivation rec {
  meta = with stdenv.lib; {
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
