{ buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage {
  name = "package";

  src = ../fixtures/make;

  checkInputs = [
    pytestCheckHook
  ];
}
