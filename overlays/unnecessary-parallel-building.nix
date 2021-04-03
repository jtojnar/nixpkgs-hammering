final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  checkDerivation = drvArgs: drv:
    lib.singleton {
      name = "unnecessary-parallel-building";
      cond =
        let
          inputs = drvArgs.nativeBuildInputs or [ ] ++ drvArgs.propagatedBuildInputs or [ ] ++ drvArgs.nativeBuildInputs or [ ];
          toolConfigureHookNotDisabled =
            (lib.elem prev.meson inputs && !drvArgs.dontUseMesonConfigure or false) ||
            (lib.elem prev.cmake inputs && !drvArgs.dontUseCmakeConfigure or false) ||
            (lib.elem prev.qt5.qmake inputs && !drvArgs.dontUseQmakeConfigure or false);
          hasEnableParallelBuilding = drvArgs.enableParallelBuilding or false;
          hasDefaultConfigurePhase = ! (drvArgs ? configurePhase);
        in
          toolConfigureHookNotDisabled && hasEnableParallelBuilding && hasDefaultConfigurePhase;
      msg = ''
        Meson, CMake and qmake already set `enableParallelBuilding = true` by default so it is not necessary.
      '';
      locations = [
        (builtins.unsafeGetAttrPos "enableParallelBuilding" drvArgs)
      ];
    };

in
  checkMkDerivationFor checkDerivation final prev
