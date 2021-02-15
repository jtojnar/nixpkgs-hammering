{ pkgs
}:

{
  # positive cases
  exception = pkgs.callPackage ./exception.nix { };

  # negative cases
  no-exception = pkgs.callPackage ./no-exception.nix { };
}
