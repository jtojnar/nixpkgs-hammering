{
  python3,
}:

{
  # positive cases
  redundant-pytest = python3.pkgs.callPackage ./redundant-pytest.nix { };

  # negative cases
  nonredundant-pytest = python3.pkgs.callPackage ./nonredundant-pytest.nix { };
}
