{
  buildPythonPackage,
  python3Full,
}:

buildPythonPackage rec {
  name = "python-inconsistent-interpreters--mixed-checkInputs";

  checkInputs = [
    python3Full.pkgs.numpy
  ];
}
