final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkFor;

  licenses = [
    "agpl3"
    "gpl2"
    "gpl3"
    "lgpl2"
    "lgpl21"
    "lgpl3"
  ];

  checkDerivation = drvArgs: drv:
    (map
      (license: {
        name = "unclear-gpl";
        cond = lib.elem lib.licenses.${license} (lib.toList (drvArgs.meta.license or []));
        msg = ''
          `${license}` is a deprecated license, please check if project uses `${license}Plus` or `${license}Only` and change `meta.license` accordingly.
        '';
        locations = [
          (builtins.unsafeGetAttrPos "license" drvArgs.meta)
        ];
      })
      licenses
    );

in
  checkFor checkDerivation final prev
