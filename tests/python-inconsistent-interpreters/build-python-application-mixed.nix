{ buildPythonApplication
, python37Packages
, python39Packages
}:

buildPythonApplication rec {
  name = "package";

  propagatedBuildInputs = [
    python37Packages.numpy
    python39Packages.scipy
  ];
}
