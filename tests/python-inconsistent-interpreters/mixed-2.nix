{ buildPythonPackage
, python27Packages
}:

buildPythonPackage rec {
  pname = "package";

  checkInputs = [
    python27Packages.numpy
  ];
}
