{ lib
}:

rec {
  attrByPathString = attrPath: lib.getAttrFromPath (lib.splitString "." attrPath);
  filterReports = reports: map (r: builtins.removeAttrs r [ "cond" ]) reports;

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

  # Creates a function based on the original one, that, when called on
  # one of the requested packages, runs a check on the arguments passed to it
  # and then returns the original result enriched with the reports.
  wrapFunctionWithChecks =
    originalFunction:
    namePositions:
    check:

    args:

    let
      originalDrv = originalFunction args;
      namePosition = originalDrv.meta.position;
    in
      if builtins.elem namePosition namePositions
      then
        addReports originalDrv (lib.filter ({ cond, ... }: cond) (check args originalDrv))
      else
        originalDrv;

  # Creates an overlay that replaces stdenv.mkDerivation with a function that,
  # for packages with locations of name attribute matching one of the namePositions,
  # checks the attribute set passed as argument to mkDerivation.
  checkMkDerivationFor =
    check:

    { namePositions
    , ...
    }:

    final:
    prev:

    {
      stdenv = prev.stdenv // {
        mkDerivation = wrapFunctionWithChecks prev.stdenv.mkDerivation namePositions check;
      };
    };

    # Creates an overlay that replaces buildPythonPackage with a function that,
    # for packages with locations of name attribute matching one of the namePositions,
    # checks the attribute set passed as argument
    checkBuildPythonPackageFor =
      check:
      {
        namePositions
        , ...
      }:
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
              buildPythonPackage = wrapFunctionWithChecks prev.buildPythonPackage namePositions check;
            });
          }));

    checkFor = check:
      let
        o1 = (checkMkDerivationFor check);
        o2 = (checkBuildPythonPackageFor check);
      in attrs: lib.composeExtensions (o1 attrs) (o2 attrs);
}
