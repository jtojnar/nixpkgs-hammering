{ callPackage
}:

{
  # positive cases
  platforms-all = callPackage ./platforms-all.nix { };
  build-python-application-platforms-all = callPackage ./build-python-application-platforms-all.nix { };

  # negative cases
  platforms-linux = callPackage ./platforms-linux.nix { };
  unspecified = callPackage ./unspecified.nix { };
  build-python-application-platforms-linux = callPackage ./build-python-application-platforms-linux.nix { };
}
