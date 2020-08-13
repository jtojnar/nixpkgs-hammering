{ pkgs ? (import ../default.nix).inputs.nixpkgs.legacyPackages.${builtins.currentSystem}
}:

{
  build-tools-in-build-inputs = pkgs.recurseIntoAttrs (pkgs.callPackage ./build-tools-in-build-inputs { });
  meson-cmake = pkgs.callPackage ./meson-cmake { };
}
