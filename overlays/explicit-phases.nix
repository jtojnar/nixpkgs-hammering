{ builtAttrs
, packageSet
, namePositions
}@attrs:

final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  phases = [
    "configure"
    "build"
    "check"
    "install"
  ];

  checkDerivation = drv:
    (map
      (phase: {
        name = "explicit-phases";
        cond = drv ? "${phase}Phase";
        msg = ''
          It is a good idea to avoid overriding `${phase}Phase` when possible.
        '';
        locations = [
          (builtins.unsafeGetAttrPos "${phase}Phase" drv)
        ];
      })
      phases
    );

in
  checkMkDerivationFor attrs prev checkDerivation
