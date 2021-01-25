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

  checkDerivation = drvArgs: drv:
    (map
      (tool: {
        name = "build-tools-in-build-inputs";
        cond = lib.elem prev.${tool} (drvArgs.buildInputs or [ ]);
        msg = ''
          ${tool} is a build tool so it likely goes to `nativeBuildInputs`, not `buildInputs`.
        '';
        locations = [
          (builtins.unsafeGetAttrPos "buildInputs" drvArgs)
        ];
      })
      buildTools
    );

in
  checkMkDerivationFor checkDerivation attrs final prev
