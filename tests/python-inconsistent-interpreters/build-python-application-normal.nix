{ buildPythonApplication
, numpy
, scipy
}:

buildPythonApplication rec {
  name = "package";

  propagatedBuildInputs = [
    numpy
    scipy
  ];
}
