{ callPackage }:

{
  positive = callPackage ./positive.nix { };

  negative = callPackage ./negative.nix { };
  everything = callPackage ./everything.nix { };
}
