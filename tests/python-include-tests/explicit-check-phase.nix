{ buildPythonPackage
}:

buildPythonPackage {
  name = "package";

  src = ../fixtures/make;

  checkPhase = "";
}
