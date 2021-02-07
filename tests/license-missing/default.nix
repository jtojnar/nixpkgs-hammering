{ pkgs
}:

{
  # positive cases
  no-license = pkgs.callPackage ./no-license.nix { };
  empty-license = pkgs.callPackage ./empty-license.nix { };
  no-meta = pkgs.callPackage ./no-meta.nix { };

  # negative cases
  have-license = pkgs.callPackage ./have-license.nix {};
}
