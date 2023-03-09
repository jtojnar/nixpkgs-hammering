{
  buildPythonPackage,
  python311Packages,
  python39Packages,
}:

buildPythonPackage rec {
  name = "python-inconsistent-interpreters--mixed-propagatedBuildInputs";

  propagatedBuildInputs = [
    python311Packages.numpy
    python39Packages.scipy
  ];
}
