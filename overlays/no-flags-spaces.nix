final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  flagAttrs = [
    "cmakeFlags"
    "mesonFlags"
    "configureFlags"
    "qmakeFlags"
    "makeFlags"
    "ninjaFlags"
    "buildFlags"
    "checkFlags"
    "installFlags"
    "installCheckFlags"
    "distFlags"
  ];

  containsSpace = str: builtins.match ".*[[:space:]].*" (builtins.toString str) != null;

  checkDerivation = drvArgs: drv:
    (map
      (flagAttr: {
        name = "no-flags-spaces";
        severity = "error";
        cond =
          let
            attr = drvArgs.${flagAttr} or [];
          in
            builtins.isList attr && builtins.any containsSpace attr;
        msg = ''
          `${flagAttr}` cannot contain spaces, please use `${flagAttr}Array` in Bash.
        '';
        locations = [
          (builtins.unsafeGetAttrPos flagAttr drvArgs)
        ];
      })
      flagAttrs
    );
in
  checkMkDerivationFor checkDerivation final prev
