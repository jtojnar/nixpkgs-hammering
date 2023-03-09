{
  python3,
}:

{
  # positive cases
  mixed-1 = python3.pkgs.callPackage ./mixed-1.nix { };
  mixed-2 = python3.pkgs.callPackage ./mixed-2.nix { };

  # negative cases
  normal = python3.pkgs.callPackage ./normal.nix { };
}
