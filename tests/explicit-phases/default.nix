{ pkgs
}:

{
  configure = pkgs.callPackage ./configure.nix { };
  build = pkgs.callPackage ./build.nix { };
  check = pkgs.callPackage ./check.nix { };
  install = pkgs.callPackage ./install.nix { };
}
