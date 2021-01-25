{ builtAttrs
, packageSet
, namePositions
}@attrs:

final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  checkDerivation = drvArgs: drv:
    lib.singleton {
      name = "meson-cmake";
      cond = lib.elem prev.meson (drvArgs.nativeBuildInputs or [ ]) && lib.elem prev.cmake (drvArgs.nativeBuildInputs or [ ]);
      msg = ''
        Meson uses CMake as a fallback dependency resolution method and it likely is not necessary here. The message about cmake not being found is purely informational.
      '';
      locations = [
        (builtins.unsafeGetAttrPos "nativeBuildInputs" drvArgs)
      ];
    };

in
  checkMkDerivationFor checkDerivation attrs final prev
