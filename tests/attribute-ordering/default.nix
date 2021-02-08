{ pkgs
}:

{
  # positive cases
  out-of-order = pkgs.callPackage ./out-of-order.nix { };

  # negative cases
  inherited = pkgs.callPackage ./inherited.nix { };
  properly-ordered = pkgs.callPackage ./properly-ordered.nix { };
}
