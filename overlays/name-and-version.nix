final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  checkDerivation = drvArgs: drv:
    lib.singleton {
      name = "name-and-version";
      cond = drvArgs ? name
          && drvArgs ? version
          && !(drvArgs ? pname);
      msg = ''
        Did you mean to pass `pname` instead of `name` to `mkDerivation`?
      '';
      locations = [
        (builtins.unsafeGetAttrPos "name" drvArgs)
        (builtins.unsafeGetAttrPos "version" drvArgs)
      ];
    };

in
  checkMkDerivationFor checkDerivation final prev
