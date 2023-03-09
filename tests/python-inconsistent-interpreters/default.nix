{
  python3,
}:

{
  # positive cases
  mixed-checkInputs = python3.pkgs.callPackage ./mixed-checkInputs.nix { };
  mixed-propagatedBuildInputs = python3.pkgs.callPackage ./mixed-propagatedBuildInputs.nix { };

  # negative cases
  normal = python3.pkgs.callPackage ./normal.nix { };
}
