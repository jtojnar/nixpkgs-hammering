{ buildPythonPackage
, numpy
}:

buildPythonPackage {
  pname = "patch-phase";

  src = ../fixtures/make;

  propagatedBuildInputs = [ numpy ];
  checkInputs = [ numpy ];
}
