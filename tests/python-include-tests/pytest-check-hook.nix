{ buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage {
  name = "package";

  src = ../fixtures/make;

  nativeCheckInputs = [
    pytestCheckHook
  ];
}
