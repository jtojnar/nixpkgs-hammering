{ callPackage
}:

{
  # positive cases
  no-tests = callPackage ./no-tests.nix { };

  # negative cases
  pytest = callPackage ./pytest.nix { };
}
