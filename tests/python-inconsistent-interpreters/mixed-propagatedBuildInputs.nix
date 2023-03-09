{
  buildPythonPackage,
  python37Packages,
  python39Packages,
}:

buildPythonPackage rec {
  name = "python-inconsistent-interpreters--mixed-propagatedBuildInputs";

  propagatedBuildInputs = [
    python37Packages.numpy
    python39Packages.scipy
  ];
}
