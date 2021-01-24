{ buildPythonPackage
}:

buildPythonPackage {
  pname = "pythonImportTests";

  src = ../fixtures/make;

  pythonImportTests = [];
}
