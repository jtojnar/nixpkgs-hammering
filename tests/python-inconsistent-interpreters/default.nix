{ callPackage
}:

{
  # positive cases
  mixed-1 = callPackage ./mixed-1.nix { };
  mixed-2 = callPackage ./mixed-2.nix { };

  # negative cases
  normal = callPackage ./normal.nix { };
}
