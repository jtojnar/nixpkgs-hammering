{ pkgs
}:

{
  # positive cases
  out-of-order = pkgs.callPackage ./out-of-order.nix { };

  # negative cases
  properly-ordered = pkgs.callPackage ./properly-ordered.nix { };
}
