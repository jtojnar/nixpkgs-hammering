{ buildPythonPackage
}:

buildPythonPackage {
  name = "pythonImportTests";

  src = ../fixtures/make;

  pythonImportTests = [];
}
