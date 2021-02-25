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

  checkDerivation = drvArgs: drv:
    (map
      (phase:
        let
          preMissing = builtins.match ".*runHook pre${capitalize phase}.*"  drvArgs."${phase}Phase" == null;
          postMissing = builtins.match ".*runHook post${capitalize phase}.*" drvArgs."${phase}Phase" == null;
        in {
          name = "missing-phase-hooks";
          cond = (
            drvArgs ? "${phase}Phase" &&
            drvArgs."${phase}Phase" != null &&
            builtins.isString drvArgs."${phase}Phase" &&
            (preMissing || postMissing)
          );
          msg = ''
            `${phase}Phase` should probably contain ${lib.optionalString preMissing "`runHook pre${capitalize phase}`"}${lib.optionalString (preMissing && postMissing) " and "}${lib.optionalString postMissing "`runHook post${capitalize phase}`"}.
          '';
          locations = [
            (builtins.unsafeGetAttrPos "${phase}Phase" drvArgs)
          ];
        }
      )
      phases
    );

in
  checkMkDerivationFor checkDerivation attrs final prev
