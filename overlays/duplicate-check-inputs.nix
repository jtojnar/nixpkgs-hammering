{ builtAttrs
, packageSet
, namePositions
}@attrs:

final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkFor;

  checkDerivation = drvArgs: drv:
    let
      list1 = drvArgs.propagatedBuildInputs or [];
      list2 = drvArgs.checkInputs or [];
      intersection = lib.intersectLists list1 list2;
    in
      lib.singleton {
        name = "duplicate-check-inputs";
        cond = builtins.length intersection > 0;
        msg = ''
          Dependencies listed in `propagatedBuildInputs` should not be repeated in `checkInputs`.

          Detected duplicates:

          ${lib.concatMapStringsSep "\n" (n: "- ${n}") (map (d: d.name) intersection)}
        '';
        locations = [
          (builtins.unsafeGetAttrPos "checkInputs" drvArgs)
          (builtins.unsafeGetAttrPos "propagatedBuildInputs" drvArgs)
        ];
      };
in
  checkFor checkDerivation attrs final prev
