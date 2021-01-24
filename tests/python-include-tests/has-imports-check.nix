{ buildPythonPackage
}:

buildPythonPackage {
  pname = "package";

  src = ../fixtures/make;

  pythonImportsCheck = [
  ];
}
