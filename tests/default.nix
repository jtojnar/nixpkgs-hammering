{ pkgs ? (import ../default.nix).inputs.nixpkgs.legacyPackages.${builtins.currentSystem}
}:

{
  build-tools-in-build-inputs = pkgs.recurseIntoAttrs (pkgs.callPackage ./build-tools-in-build-inputs { });
  explicit-phases = pkgs.callPackage ./explicit-phases { };
  fixup-phase = pkgs.callPackage ./fixup-phase { };
  meson-cmake = pkgs.callPackage ./meson-cmake { };
  missing-phase-hooks = pkgs.callPackage ./missing-phase-hooks { };
  patch-phase = pkgs.callPackage ./patch-phase { };
  unnecessary-parallel-building = pkgs.callPackage ./unnecessary-parallel-building { };
}
