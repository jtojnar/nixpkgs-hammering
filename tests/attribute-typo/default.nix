{ pkgs
}:

{
  # positive cases
  casing = pkgs.callPackage ./casing.nix { };
  deletion = pkgs.callPackage ./deletion.nix { };
  insertion = pkgs.callPackage ./insertion.nix { };
  transposition = pkgs.callPackage ./transposition.nix { };

  # negative cases
  properly-ordered = pkgs.callPackage ../attribute-ordering/properly-ordered.nix { };
  unknown-short = pkgs.callPackage ./unknown-short.nix { };
}
