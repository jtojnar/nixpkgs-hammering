{ lib
}:

rec {
  attrByPathString = attrPath: lib.getAttrFromPath (lib.splitString "." attrPath);

  # Removes reports with `cond == false` and then strips the `cond` attribute.
  filterReports = reports:
    map (report: builtins.removeAttrs report [ "cond" ]) (lib.filter ({ cond, ... }: cond) reports);

  # Get the location of a drv. Return either an attset containing the fields 'file' and 'line'
  # or null.
  getLocation = drv:
    let
      position = drv.meta.position or null;
      posSplit = builtins.split ":" position;
    in
      if position == null then
        null
      else {
        file = builtins.elemAt posSplit 0;
        line = lib.toInt (builtins.elemAt posSplit 2);
      };

  capitalize = str:
    if builtins.stringLength str == 0 then
      str
    else
      let
        head = builtins.substring 0 1 str;
        tail = builtins.substring 1 (builtins.stringLength str - 1) str;
      in
        lib.toUpper head + tail;

  # Attaches reports to a package’s attribute set.
  addReports =
    originalDrv:
    reports:

    lib.recursiveUpdate originalDrv {
      __nixpkgs-hammering-state = {
        reports = lib.unique (originalDrv.__nixpkgs-hammering-state.reports or [] ++ filterReports reports);
      };
    };

  # Identity element for overlays.
  idOverlay = final: prev: {};

  # Creates a function based on the original one, that runs a check
  # on the arguments passed to it and then returns the original result
  # enriched with the reports.
  wrapFunctionWithChecks =
    originalFunction:
    check:

    args:

    let
      originalDrv = originalFunction args;
      namePosition = originalDrv.meta.position or null;
    in
      addReports originalDrv (check args originalDrv);

  # Creates an overlay that replaces stdenv.mkDerivation with a function that
  # checks the attribute set passed as argument to mkDerivation.
  checkMkDerivationFor =
    check:

    final:
    prev:

    {
      stdenv = prev.stdenv // {
        mkDerivation = wrapFunctionWithChecks prev.stdenv.mkDerivation check;
      };
    };

  # Creates an overlay that replaces buildPythonPackage with a function that
  # checks the attribute set passed as argument to it.
  checkBuildPythonPackageFor =
    check:

    final:
    prev:

    let
      # Keep in sync with Nixpkgs’s all-packages.nix.
      pythonPackageSetNames = [
        "python"
        "python2"
        "python3"
        "pypy"
        "pypy2"
        "pypy3"
        "python27"
        "python36"
        "python37"
        "python38"
        "python39"
        "python310"
        "python3Minimal"
        "pypy27"
        "pypy36"
      ];

    in
      lib.genAttrs pythonPackageSetNames (pythonName:
        prev.${pythonName}.override (oldOverrides: {
          packageOverrides = lib.composeExtensions (oldOverrides.packageOverrides or idOverlay) (final: prev: {
            buildPythonApplication = wrapFunctionWithChecks prev.buildPythonApplication check;
            buildPythonPackage = wrapFunctionWithChecks prev.buildPythonPackage check;
          });
        })
      );

  # Creates an overlay that replaces all supported functions for creating derivations
  # with a function that checks the attribute set passed as argument to it.
  checkFor = check:
    let
      o1 = (checkMkDerivationFor check);
      o2 = (checkBuildPythonPackageFor check);
    in lib.composeExtensions o1 o2;
}
