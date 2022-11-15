{ lib
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "package";
  version = "0.1.0";

  meta = with lib; {
    platforms = platforms.linux;
  };
}
