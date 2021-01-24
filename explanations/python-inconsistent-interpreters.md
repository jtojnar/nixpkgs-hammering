Each Python package expression in nixpkgs should take its inputs in such a way that it can be properly built for multiple different Python interpreters.

For example, the following is incorrect:

```nix
{ lib
, buildPythonPackage
, python3Packages
}:

buildPythonPackage rec {
  pname = "mypackage";
  …
  propagatedBuildInputs = [
    python3Packages.numpy
  ];
}
```

Instead, it should be:

```nix
{ lib
, buildPythonPackage
, numpy
}:

buildPythonPackage rec {
  pname = "mypackage";
  …
  propagatedBuildInputs = [
    numpy
  ];
}
```

This design allows nixpkgs to ensure that the version of Python pulled in by `numpy` is the same as the version that the package uses.
