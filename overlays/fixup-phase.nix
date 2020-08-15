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
      cond = drv ? fixupPhase;
      msg = ''
        `fixupPhase` should not be overridden, use `postFixup` instead.

        See: https://github.com/jtojnar/nixpkgs-hammering/blob/master/explanations/fixup-phase.md
      '';
    };

in
  checkMkDerivationFor attrs prev checkDerivation
