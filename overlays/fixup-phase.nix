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
      name = "fixup-phase";
      cond = drv ? fixupPhase;
      msg = ''
        `fixupPhase` should not be overridden, use `postFixup` instead.
      '';
      locations = [
        (builtins.unsafeGetAttrPos "fixupPhase" drv)
      ];
    };

in
  checkMkDerivationFor attrs prev checkDerivation
