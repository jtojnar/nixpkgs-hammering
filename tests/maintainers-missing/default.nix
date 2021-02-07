{ pkgs
}:

{
  # positive cases
  no-maintainers = pkgs.callPackage ./no-maintainers.nix { };
  empty-maintainers = pkgs.callPackage ./empty-maintainers.nix { };
  no-meta = pkgs.callPackage ./no-meta.nix { };

  # negative cases
  have-maintainers = pkgs.callPackage ./have-maintainers.nix { };
}
