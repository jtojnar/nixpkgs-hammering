{ buildPythonPackage
}:

buildPythonPackage {
  pname = "pythonCheckImports";

  src = ../fixtures/make;

  pythonCheckImports = [];
}
