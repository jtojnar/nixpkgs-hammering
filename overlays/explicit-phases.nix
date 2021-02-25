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

  checkDerivation = drvArgs: drv:
    (map
      (phase: {
        name = "explicit-phases";
        cond = drvArgs ? "${phase}Phase";
        msg = ''
          It is a good idea to avoid overriding `${phase}Phase` when possible.
        '';
        locations = [
          (builtins.unsafeGetAttrPos "${phase}Phase" drvArgs)
        ];
      })
      phases
    );

in
  checkMkDerivationFor checkDerivation final prev
