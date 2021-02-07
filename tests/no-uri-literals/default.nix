{ callPackage
}:

{
  # positive cases
  uri-literal = callPackage ./uri-literal.nix { };

  # negative cases
  string = callPackage ./string.nix { };
}
