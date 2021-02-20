{ buildPythonPackage
}:

buildPythonPackage {
  name = "pythonImportCheck";

  src = ../fixtures/make;

  pythonImportCheck = [];
}
