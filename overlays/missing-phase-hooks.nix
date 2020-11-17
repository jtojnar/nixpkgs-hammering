{ builtAttrs
, packageSet
, namePositions
}@attrs:

final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) capitalize checkMkDerivationFor;

  phases = [
    "configure"
    "build"
    "check"
    "install"
  ];

  checkDerivation = drv:
    (map
      (phase:
        let
          preMissing = builtins.match ".*runHook pre${capitalize phase}.*"  drv."${phase}Phase" == null;
          postMissing = builtins.match ".*runHook post${capitalize phase}.*" drv."${phase}Phase" == null;
        in {
          cond = drv ? "${phase}Phase" && drv."${phase}Phase" != null && (preMissing || postMissing);
          msg = ''
            `${phase}Phase` should probably contain ${lib.optionalString preMissing "`runHook pre${capitalize phase}`"}${lib.optionalString (preMissing && postMissing) " and "}${lib.optionalString postMissing "`runHook post${capitalize phase}`"}.

            See: https://github.com/jtojnar/nixpkgs-hammering/blob/master/explanations/missing-phase-hooks.md
          '';
        }
      )
      phases
    );

in
  checkMkDerivationFor attrs prev checkDerivation
