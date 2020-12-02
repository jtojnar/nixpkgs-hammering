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
        mkDerivation = drv:
          let
            originalDrv = prev.stdenv.mkDerivation drv;
            namePosition =
              let
                pnamePosition = builtins.unsafeGetAttrPos "pname" drv;
              in
                if pnamePosition != null then pnamePosition else builtins.unsafeGetAttrPos "name" drv;
          in
            if builtins.elem namePosition namePositions
            then
              lib.recursiveUpdate originalDrv {
                __nixpkgs-hammering-state = {
                  reports = originalDrv.__nixpkgs-hammering-state.reports or [] ++ lib.filter ({ cond, ... }: cond) (check drv);
                };
              }
            else
              originalDrv;
      };
    };
}
