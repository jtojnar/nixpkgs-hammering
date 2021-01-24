{ buildPythonPackage
, numpy
, scipy
}:

buildPythonPackage rec {
  pname = "package";

  propagatedBuildInputs = [
    numpy
    scipy
  ];
}
