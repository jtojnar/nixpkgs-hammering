{ builtAttrs
, packageSet
, namePositions
}@attrs:

final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkBuildPythonPackageFor;
  regex = "[[:space:]]*pytest[[:space:]]*";

  checkDerivation = drvArgs: drv:
    lib.singleton {
      name = "python-explicit-check-phase";
      cond = (drvArgs ? checkPhase) && (builtins.match regex drvArgs.checkPhase) != null;
      msg = ''
        Consider using `pytestCheckHook` in `checkInputs` rather than `checkPhase = "pytest";`.
      '';
      locations = [
        (builtins.unsafeGetAttrPos "checkPhase" drvArgs)
      ];
    };
in
  checkBuildPythonPackageFor checkDerivation attrs final prev
