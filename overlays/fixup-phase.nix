final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  checkDerivation = drvArgs: drv:
    lib.singleton {
      name = "fixup-phase";
      cond = drvArgs ? fixupPhase;
      msg = ''
        `fixupPhase` should not be overridden, use `postFixup` instead.
      '';
      locations = [
        (builtins.unsafeGetAttrPos "fixupPhase" drvArgs)
      ];
    };

in
  checkMkDerivationFor checkDerivation final prev
