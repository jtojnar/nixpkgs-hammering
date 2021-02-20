{ buildPythonPackage
}:

buildPythonPackage {
  name = "pythonCheckImports";

  src = ../fixtures/make;

  pythonCheckImports = [];
}
