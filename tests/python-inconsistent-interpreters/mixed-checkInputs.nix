{
  buildPythonPackage,
  python27Packages,
}:

buildPythonPackage rec {
  name = "python-inconsistent-interpreters--mixed-checkInputs";

  checkInputs = [
    python27Packages.numpy
  ];
}
