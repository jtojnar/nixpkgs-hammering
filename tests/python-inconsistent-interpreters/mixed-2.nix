{ buildPythonPackage
, python27Packages
}:

buildPythonPackage rec {
  name = "package";

  checkInputs = [
    python27Packages.numpy
  ];
}
