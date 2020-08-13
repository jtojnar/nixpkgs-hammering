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
      cond = lib.elem prev.meson (drv.nativeBuildInputs or [ ]) && lib.elem prev.cmake (drv.nativeBuildInputs or [ ]);
      msg = ''
        Meson uses CMake as a fallback dependency resolution method and it likely is not necessary here. The message about cmake not being found is purely informational.

        See: https://github.com/jtojnar/nixpkgs-hammering/blob/master/explanations/meson-cmake.md
      '';
    };

in
  checkMkDerivationFor attrs prev checkDerivation
