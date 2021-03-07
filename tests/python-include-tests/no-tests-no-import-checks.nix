{ buildPythonPackage
}:

buildPythonPackage {
  name = "package";

  format = "pyproject";

  src = ../fixtures/make;
}
