{
  buildPythonPackage,
  numpy,
  scipy,
}:

buildPythonPackage rec {
  name = "mixed-normal";

  propagatedBuildInputs = [
    numpy
    scipy
  ];
}
