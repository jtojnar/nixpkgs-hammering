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
          name = "missing-phase-hooks";
          cond = drv ? "${phase}Phase" && drv."${phase}Phase" != null && (preMissing || postMissing);
          msg = ''
            `${phase}Phase` should probably contain ${lib.optionalString preMissing "`runHook pre${capitalize phase}`"}${lib.optionalString (preMissing && postMissing) " and "}${lib.optionalString postMissing "`runHook post${capitalize phase}`"}.
          '';
          locations = [
            (builtins.unsafeGetAttrPos "${phase}Phase" drv)
          ];
        }
      )
      phases
    );

in
  checkMkDerivationFor checkDerivation attrs final prev
