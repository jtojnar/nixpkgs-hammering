{ lib
}:

rec {
  attrByPathString = attrPath: lib.getAttrFromPath (lib.splitString "." attrPath);

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
        reports = originalDrv.__nixpkgs-hammering-state.reports or [] ++ reports;
      };
    };

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
      namePosition =
        let
          pnamePosition = builtins.unsafeGetAttrPos "pname" args;
        in
          if pnamePosition != null then pnamePosition else builtins.unsafeGetAttrPos "name" args;
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
}
