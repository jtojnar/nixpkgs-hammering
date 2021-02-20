{ buildPythonPackage
}:

buildPythonPackage {
  name = "redundant-pytest";

  src = ../fixtures/make;

  checkPhase = "  pytest ";
}
