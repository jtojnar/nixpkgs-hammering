{ builtAttrs
, packageSet
, namePositions
}@attrs:

final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkBuildPythonPackageFor;

  checkDerivation = drvArgs: drv:
    lib.singleton {
      name = "python-include-tests";
      cond =
        let
          hasCheckPhase = drvArgs ? checkPhase;
          hasDoCheckFalse = (drvArgs ? doCheck) && (drvArgs.doCheck == false);
          hasPytestCheckHook = drvArgs ? checkInputs && lib.any (n: (n.name or "") == "pytest-check-hook") drvArgs.checkInputs;
          hasPythonImportsCheck = drvArgs ? pythonImportsCheck;

          hasActiveCheckPhase = (hasCheckPhase || hasPytestCheckHook) && (!hasDoCheckFalse);
        in
          !(hasActiveCheckPhase || hasPythonImportsCheck);
      msg = ''
        Add a `checkPhase` for tests, or at least `pythonImportsCheck`.
      '';
    };
in
  checkBuildPythonPackageFor checkDerivation attrs final prev
