{ buildPythonPackage
}:

buildPythonPackage {
  pname = "pythonImportCheck";

  src = ../fixtures/make;

  pythonImportCheck = [];
}
