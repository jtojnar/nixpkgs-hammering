{ callPackage
}:

{
  # positive cases
  make = callPackage ./make.nix { };
  make-finalAttrs = callPackage ./make-finalAttrs.nix { };
}
