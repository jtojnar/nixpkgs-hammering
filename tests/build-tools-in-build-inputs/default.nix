{ pkgs
}:

{
  cmake = pkgs.callPackage ./cmake.nix { };
  meson = pkgs.callPackage ./meson.nix { };
  ninja = pkgs.callPackage ./ninja.nix { };
  pkg-config = pkgs.callPackage ./pkg-config.nix { };
}
