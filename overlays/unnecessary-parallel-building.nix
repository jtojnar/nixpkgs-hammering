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
        in
          (lib.elem prev.meson inputs || lib.elem prev.cmake inputs || lib.elem prev.qt5.qmake inputs) && drvArgs.enableParallelBuilding or false;
      msg = ''
        Meson, CMake and qmake already set `enableParallelBuilding = true` by default so it is not necessary.
      '';
      locations = [
        (builtins.unsafeGetAttrPos "enableParallelBuilding" drvArgs)
      ];
    };

in
  checkMkDerivationFor checkDerivation final prev
