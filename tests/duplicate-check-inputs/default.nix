{ buildPythonPackage
, numpy
}:

buildPythonPackage {
  name = "patch-phase";

  src = ../fixtures/make;

  propagatedBuildInputs = [ numpy ];
  checkInputs = [ numpy ];
}
