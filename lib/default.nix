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

  replicate = n: x: builtins.concatStringsSep "" (builtins.genList (_: x) n);

  printLocation = { file, line, column }:
    let
      allLines = lib.splitString "\n" (builtins.readFile file);
      lineContents = builtins.elemAt allLines (line - 1);
      lineSpaces = replicate (builtins.stringLength (builtins.toString line)) " ";
      pointer = replicate (column - 1) " " + "^";
    in
      file + ":" + builtins.toString line + ":" + builtins.toString column + ":\n" +
      lineSpaces + " |\n" +
      builtins.toString line + " | " + lineContents + "\n" +
      lineSpaces + " | " + pointer + "\n";

  printError = { name, msg, locations ? [], ... }:
    msg +
    lib.concatMapStringsSep "\n" printLocation locations +
    "See: https://github.com/jtojnar/nixpkgs-hammering/blob/master/explanations/${name}.md";

  warn = warnings:
    let
      matchedWarnings = lib.filter ({ cond, ... }: cond) warnings;
    in
      if builtins.length matchedWarnings > 0 then
        lib.warn (lib.concatMapStringsSep "\n" printError matchedWarnings)
      else
        lib.id;

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
              warn (check drv)
              originalDrv
            else
              originalDrv;
      };
    };
}
