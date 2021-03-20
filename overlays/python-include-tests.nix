final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkBuildPythonPackageFor getLocation;

  checkDerivation = drvArgs: drv:
    lib.singleton {
      name = "python-include-tests";
      cond =
        let
          isTestHook = name: builtins.elem name [
            "pytest-check-hook"
            "setuptools-check-hook"
          ];
          hasCheckPhase = drvArgs ? checkPhase || drvArgs ? installCheckPhase;
          hasDoCheckFalse = (drv ? doInstallCheck) && !drv.doInstallCheck;
          hasCheckHook = lib.any (n: isTestHook (n.name or "")) drv.nativeBuildInputs;
          hasPythonImportsCheck = drvArgs ? pythonImportsCheck;

          hasActiveCheckPhase = (hasCheckPhase || hasCheckHook) && (!hasDoCheckFalse);
        in
          !(hasActiveCheckPhase || hasPythonImportsCheck);
      msg = ''
        Consider adding a `checkPhase` for tests, or if not feasible, `pythonImportsCheck`.
      '';
      locations = [ (getLocation drv) ];
    };
in
  checkBuildPythonPackageFor checkDerivation final prev
