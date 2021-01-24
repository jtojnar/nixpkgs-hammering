{ buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage {
  pname = "package";

  src = ../fixtures/make;

  checkInputs = [
    pytestCheckHook
  ];
}
