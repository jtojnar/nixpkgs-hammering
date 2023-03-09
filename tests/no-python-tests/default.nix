{
  python3,
}:

{
  # positive cases
  no-tests = python3.pkgs.callPackage ./no-tests.nix { };

  # negative cases
  pytest = python3.pkgs.callPackage ./pytest.nix { };
}
