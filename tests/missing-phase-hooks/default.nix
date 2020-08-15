{ pkgs
}:

{
  configure-pre = pkgs.callPackage ./configure-pre.nix { };
  configure-post = pkgs.callPackage ./configure-post.nix { };
  configure-both = pkgs.callPackage ./configure-both.nix { };
  build-pre = pkgs.callPackage ./build-pre.nix { };
  build-post = pkgs.callPackage ./build-post.nix { };
  build-both = pkgs.callPackage ./build-both.nix { };
  check-pre = pkgs.callPackage ./check-pre.nix { };
  check-post = pkgs.callPackage ./check-post.nix { };
  check-both = pkgs.callPackage ./check-both.nix { };
  install-pre = pkgs.callPackage ./install-pre.nix { };
  install-post = pkgs.callPackage ./install-post.nix { };
  install-both = pkgs.callPackage ./install-both.nix { };
}
