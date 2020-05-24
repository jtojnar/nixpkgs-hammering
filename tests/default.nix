{ pkgs ? import <nixpkgs> {}
}:

{
  build-tools-in-build-inputs = pkgs.recurseIntoAttrs (pkgs.callPackage ./build-tools-in-build-inputs { });
}
