{ pkgs
}:

{
  cmake = pkgs.callPackage ./cmake.nix { };
  meson = pkgs.callPackage ./meson.nix { };
  qmake = pkgs.callPackage ./qmake.nix { };
  qt-derivation = pkgs.qt5.callPackage ./qt-derivation.nix { };
}
