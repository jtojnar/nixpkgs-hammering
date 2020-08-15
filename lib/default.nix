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
