{ buildPythonPackage
}:

buildPythonPackage {
  name = "pythonImportsCheck";

  src = ../fixtures/make;

  pythonImportsCheck = [];
}
