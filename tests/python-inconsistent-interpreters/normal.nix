{ buildPythonPackage
, numpy
, scipy
}:

buildPythonPackage rec {
  name = "package";

  propagatedBuildInputs = [
    numpy
    scipy
  ];
}
