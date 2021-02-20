{ buildPythonPackage
}:

buildPythonPackage {
  name = "pythonImportsTest";

  src = ../fixtures/make;

  pythonImportsTest = [];
}
