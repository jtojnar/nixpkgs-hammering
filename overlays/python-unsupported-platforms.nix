final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkBuildPythonPackageFor;

  checkDerivation = drvArgs: drv:
    let
      # We can access python with the `pythonModule` attribute of `buildPythonPackage`
      # derivations, but it is not so simple with `buildPythonApplication`. Here we rely on the
      # performance hack in nixpkgs/pkgs/development/interpreters/python/mk-python-derivation.nix
      # which injects python into propagatedBuildInputs.
      python = lib.lists.last (builtins.filter (p: p ? pythonVersion) drv.propagatedBuildInputs);
      drvPlatforms = drvArgs.meta.platforms or [ ];
      unsupportedPlatforms = lib.lists.subtractLists python.meta.platforms drvPlatforms;
    in lib.singleton {
      name = "python-unsupported-platforms";
      cond = (unsupportedPlatforms != [ ]) || (lib.lists.naturalSort drvPlatforms == lib.lists.naturalSort python.meta.platforms);
      msg = if unsupportedPlatforms != [ ] then ''
        The following meta.platforms are not supported by the ${python} interpreter:
          [ ${builtins.toString unsupportedPlatforms} ]
      '' else ''
        The meta.platforms attribute is set to the same value by default.
      '';
      locations = [
        (builtins.unsafeGetAttrPos "platforms" python.meta)
        (builtins.unsafeGetAttrPos "platforms" drvArgs.meta)
      ];
    };
in
  checkBuildPythonPackageFor checkDerivation final prev
