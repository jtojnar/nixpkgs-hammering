{ builtAttrs
, packageSet
, namePositions
}@attrs:

self: super:
let
  inherit (super) lib;
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
        cond = lib.elem super.${tool} (drv.buildInputs or [ ]);
        msg = ''
          ${tool} is a build tool so it likely goes to nativeBuildInputs, not buildInputs.

          See: https://github.com/jtojnar/nixpkgs-hammering/blob/master/explanations/build-tools-in-build-inputs.md
        '';
      })
      buildTools
    );

in
  checkMkDerivationFor attrs super checkDerivation
