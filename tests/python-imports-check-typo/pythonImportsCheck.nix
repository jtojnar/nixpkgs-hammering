{ buildPythonPackage
}:

buildPythonPackage {
  pname = "pythonImportsCheck";

  src = ../fixtures/make;

  pythonImportsCheck = [];
}
