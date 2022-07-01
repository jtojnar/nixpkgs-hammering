{ callPackage
}:

{
  # positive cases
  mixed-1 = callPackage ./mixed-1.nix { };
  mixed-2 = callPackage ./mixed-2.nix { };
  build-python-application-mixed = callPackage ./build-python-application-mixed.nix { };

  # negative cases
  normal = callPackage ./normal.nix { };
  build-python-application-normal = callPackage ./build-python-application-normal.nix { };
}
