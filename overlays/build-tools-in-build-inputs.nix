{ builtAttrs
, packageSet
, namePositions
}@attrs:

final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  buildTools = [
    "cmake"
    "meson"
    "ninja"
    "pkg-config"
  ];

  checkDerivation = drv:
    (map
      (tool: {
        name = "build-tools-in-build-inputs";
        cond = lib.elem prev.${tool} (drv.buildInputs or [ ]);
        msg = ''
          ${tool} is a build tool so it likely goes to `nativeBuildInputs`, not `buildInputs`.
        '';
        locations = [
          (builtins.unsafeGetAttrPos "buildInputs" drv)
        ];
      })
      buildTools
    );

in
  checkMkDerivationFor attrs prev checkDerivation
