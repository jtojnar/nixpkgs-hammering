{ lib
}:

rec {
  attrByPathString = attrPath: lib.getAttrFromPath (lib.splitString "." attrPath);

  warn = warnings:
    let
      matchedWarnings = lib.filter ({ cond, ... }: cond) warnings;
    in
      if builtins.length matchedWarnings > 0 then
        lib.warn (lib.concatMapStringsSep "\n" ({ msg, ... }: msg) matchedWarnings)
      else
        lib.id;

  checkMkDerivationFor =
    { builtAttrs
    , packageSet
    , namePositions
    }:

    prev:

    check:

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
              warn (check drv)
              originalDrv
            else
              originalDrv;
      };
    };
}
