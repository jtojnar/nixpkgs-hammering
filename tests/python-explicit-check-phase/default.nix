{ callPackage
}:

{
  # positive cases
  redundant-pytest = callPackage ./redundant-pytest.nix { };

  # negative cases
  nonredundant-pytest = callPackage ./nonredundant-pytest.nix { };
}
