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
      name = "unnecessary-parallel-building";
      cond =
        let
          inputs = drv.nativeBuildInputs or [ ] ++ drv.propagatedBuildInputs or [ ] ++ drv.nativeBuildInputs or [ ];
        in
          (lib.elem prev.meson inputs || lib.elem prev.cmake inputs || lib.elem prev.qt5.qmake inputs) && drv.enableParallelBuilding or false;
      msg = ''
        Meson, CMake and qmake already set `enableParallelBuilding = true` by default so it is not necessary.
      '';
      locations = [
        (builtins.unsafeGetAttrPos "enableParallelBuilding" drv)
      ];
    };

in
  checkMkDerivationFor attrs prev checkDerivation
