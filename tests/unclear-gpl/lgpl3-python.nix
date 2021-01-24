{ lib
, buildPythonPackage
}:

buildPythonPackage {
  pname = "unclear-gpl-lgpl3-python";

  src = ../fixtures/make;

  meta.license = [ lib.licenses.lgpl3 ];
}
