final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkFor;

  checkDerivation = drvArgs: drv:
    lib.singleton {
      name = "license-missing";
      cond = lib.length (lib.toList (drvArgs.meta.license or [ ])) == 0;
      msg = ''
        Package is missing a license
      '';
      locations = [
        (builtins.head (builtins.filter (l: l != null) [
          # If the package has a meta.license but it's empty, that's where the location of the
          # error is
          (builtins.unsafeGetAttrPos "license" drvArgs.meta or {})
          # Otherwise, it probably has a meta field, so that's where we'll locate the error
          (builtins.unsafeGetAttrPos "meta" drvArgs)
          # Otherwise, the package contains no meta field, so I'm not sure where we can
          # say the error is, but we'll just pick another attribute it does have?
          (builtins.unsafeGetAttrPos (builtins.head (builtins.attrNames drvArgs)) drvArgs)
        ]))
      ];
    };

in
  checkFor checkDerivation final prev
