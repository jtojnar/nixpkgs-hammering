{ builtAttrs
, packageSet
, namePositions
}:

self: super:
let
  inherit (super) lib;
  attrByPathString = attrPath: lib.getAttrFromPath (lib.splitString "." attrPath);
  warn = warnings:
    let
      matchedWarnings = lib.filter ({ cond, ... }: cond) warnings;
    in
      if builtins.length matchedWarnings > 0 then
        lib.warn (lib.concatMapStringsSep "\n" ({ msg, ... }: msg) matchedWarnings)
      else
        lib.id;
in
{
  stdenv = super.stdenv // {
    mkDerivation = drv:
      let
        buildTools = [
          "cmake"
          "meson"
          "ninja"
          "pkg-config"
        ];
        originalDrv = super.stdenv.mkDerivation drv;
        namePosition =
          let
            pnamePosition = builtins.unsafeGetAttrPos "pname" drv;
          in
            if pnamePosition != null then pnamePosition else builtins.unsafeGetAttrPos "name" drv;
      in
        if builtins.elem namePosition namePositions
        then
          warn (map
            (tool:
              {
                cond = lib.elem super.${tool} (drv.buildInputs or [ ]);
                msg = ''
                  ${tool} is a build tool so it likely goes to nativeBuildInputs, not buildInputs.

                  See: https://github.com/jtojnar/nixpkgs-hammering/blob/master/explanations/build-tools-in-build-inputs.md
                '';
              }) buildTools)
            originalDrv
        else
          originalDrv;
  };
}
