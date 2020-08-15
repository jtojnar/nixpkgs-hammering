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
      cond = drv ? patchPhase;
      msg = ''
        `patchPhase` should not be overridden, use `postPatch` instead.

        See: https://github.com/jtojnar/nixpkgs-hammering/blob/master/explanations/patch-phase.md
      '';
    };

in
  checkMkDerivationFor attrs prev checkDerivation
