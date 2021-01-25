{ builtAttrs
, packageSet
, namePositions
}@attrs:

final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  checkDerivation = drvArgs: drv:
    lib.singleton {
      name = "patch-phase";
      cond = drvArgs ? patchPhase;
      msg = ''
        `patchPhase` should not be overridden, use `postPatch` instead.
      '';
      locations = [
        (builtins.unsafeGetAttrPos "patchPhase" drvArgs)
      ];
    };

in
  checkMkDerivationFor checkDerivation attrs final prev
