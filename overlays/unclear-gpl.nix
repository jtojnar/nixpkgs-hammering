{ builtAttrs
, packageSet
, namePositions
}@attrs:

final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  licenses = [
    "agpl3"
    "fdl11"
    "fdl12"
    "fdl13"
    "gpl1"
    "gpl2"
    "gpl3"
    "lgpl2"
    "lgpl21"
    "lgpl3"
  ];

  checkDerivation = drv:
    (map
      (license: {
        cond = lib.elem lib.licenses.${license} (drv.meta.license or []);
        msg = ''
          `${license}` is a deprecated license, check if project uses `${license}Plus` or `${license}Only` and change `meta.license` accordingly.

          See: https://github.com/jtojnar/nixpkgs-hammering/blob/master/explanations/unclear-gpl.md
        '';
      })
      licenses
    );

in
  checkMkDerivationFor attrs prev checkDerivation
