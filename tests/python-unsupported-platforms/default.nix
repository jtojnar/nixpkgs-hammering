{ callPackage
}:

{
  # positive cases
  platforms-all = callPackage ./platforms-all.nix { };

  # negative cases
  platforms-linux = callPackage ./platforms-linux.nix { };
  unspecified = callPackage ./unspecified.nix { };
}
