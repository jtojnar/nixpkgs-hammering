{ builtAttrs
, packageSet
, namePositions
}@attrs:

final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  checkDerivation = drv:
    lib.singleton {
      name = "patch-phase";
      cond = drv ? patchPhase;
      msg = ''
        `patchPhase` should not be overridden, use `postPatch` instead.
      '';
      locations = [
        (builtins.unsafeGetAttrPos "patchPhase" drv)
      ];
    };

in
  checkMkDerivationFor attrs prev checkDerivation
