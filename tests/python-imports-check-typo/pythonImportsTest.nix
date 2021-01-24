{ buildPythonPackage
}:

buildPythonPackage {
  pname = "pythonImportsTest";

  src = ../fixtures/make;

  pythonImportsTest = [];
}
