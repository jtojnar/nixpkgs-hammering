{ pkgs }:

{
  # positive cases
  stale = pkgs.callPackage ./stale.nix { };

  # negative cases
  live = pkgs.callPackage ./live.nix { };
}
