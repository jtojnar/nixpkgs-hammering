{ buildPythonPackage
, python37Packages
, python39Packages
}:

buildPythonPackage rec {
  name = "package";

  propagatedBuildInputs = [
    python37Packages.numpy
    python39Packages.scipy
  ];
}
