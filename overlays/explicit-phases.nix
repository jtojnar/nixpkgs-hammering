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
        cond = drv ? "${phase}Phase";
        msg = ''
          It is a good idea to avoid overriding `${phase}Phase` when possible.

          See: https://github.com/jtojnar/nixpkgs-hammering/blob/master/explanations/explicit-phases.md
        '';
      })
      phases
    );

in
  checkMkDerivationFor attrs prev checkDerivation
