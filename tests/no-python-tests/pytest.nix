{ buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage {
  name = "package";
  src = ../fixtures/python;
  checkInputs = [ pytestCheckHook ];
}
