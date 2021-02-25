final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  arrayAttrs = [
    # Do not include makeWrapperArgs, it is type aware:
    # https://github.com/NixOS/nixpkgs/blob/fcac694fe5ca5204e276e14ea0481428172280b2/pkgs/development/interpreters/python/wrap.sh#L87
    "cmakeFlagsArray"
    "mesonFlagsArray"
    "configureFlagsArray"
    "qmakeFlagsArray"
    "makeFlagsArray"
    "ninjaFlagsArray"
    "buildFlagsArray"
    "checkFlagsArray"
    "installFlagsArray"
    "installCheckFlagsArray"
    "distFlagsArray"
  ];

  checkDerivation = drvArgs: drv:
    (map
      (arrayAttr: {
        name = "no-flags-array";
        severity = "error";
        cond = builtins.hasAttr arrayAttr drvArgs;
        msg = ''
          `${arrayAttr}` is only intended to be used in Bash, not as a Nix attribute.
        '';
        locations = [
          (builtins.unsafeGetAttrPos arrayAttr drvArgs)
        ];
      })
      arrayAttrs
    );
in
  checkMkDerivationFor checkDerivation final prev
