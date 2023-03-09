final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;
  inherit (import ../lib/levenshtein.nix { inherit lib; }) levenshtein levenshteinAtMost;

  knowAttributeNames =
    let
      flattenGroup = item:
        if builtins.isAttrs item then
          item.values
        else
          [ item ];
    in
      builtins.concatMap flattenGroup (import ../lib/derivation-attributes.nix) ++ import ../lib/derivation-attributes-unordered.nix ++ import ../lib/environment-variables.nix;

  knownAttributeNamesLowerMapping = builtins.listToAttrs (map (item: { name = lib.toLower item; value = item; }) knowAttributeNames);
  knownAttributeNamesLower = builtins.attrNames knownAttributeNamesLowerMapping;

  isUnknownAttr = name: !builtins.elem name knowAttributeNames;

  # Get a list of suggested argument names for a given unknown one
  # Based on infinisil’s code from https://github.com/NixOS/nixpkgs/pull/79877
  getSuggestions = argName:
    let
      argNameLower = lib.toLower argName;
      argLength = builtins.stringLength argName;
      maxDistance =
        if argLength <= 7 then
          1
        else if argLength <= 9 then
          2
        else
          4;
    in
      if builtins.hasAttr argNameLower knownAttributeNamesLowerMapping then
        # Casing mismatch
        lib.singleton (builtins.getAttr argNameLower knownAttributeNamesLowerMapping)
      else if argLength <= 5 then
        # Too short, only casing typos are checked.
        []
      else
        # Look for close matches
        lib.pipe knownAttributeNamesLower [
          # Only use ones that are at most maxDistance edits away.
          # levenshteinAtMost is only fast for 2 or less so this is suboptimal but it will have to do for now.
          (builtins.filter (levenshteinAtMost maxDistance argNameLower))
          # Put strings with shorter distance first.
          (lib.sort (a: b: levenshtein a argNameLower < levenshtein b argNameLower))
          # Only take the first couple results.
          (lib.take 3)
          # Quote all entries.
          (map (n: knownAttributeNamesLowerMapping.${n}))
        ];

  prettySuggestions = unquotedSuggestions:
    let
      suggestions = map (s: "`${s}`") unquotedSuggestions;
    in
      if suggestions == [] then
        "."
      else if lib.length suggestions == 1 then
        ", did you mean ${lib.elemAt suggestions 0}?"
      else
        ", did you mean ${lib.concatStringsSep ", " (lib.init suggestions)} or ${lib.last suggestions}?";

  checkDerivation = drvArgs: drv:
    let
      unknownAttributeNames = builtins.filter isUnknownAttr (builtins.attrNames drvArgs);
    in
      map
        (argName:
          let
            suggestions = getSuggestions argName;
          in {
            name = "attribute-typo";
            # Comment out the following line to see all unknown attributes (when extending our lexicon).
            cond = builtins.length suggestions > 0;
            msg = ''
              A likely typo in the `${argName}` argument was found${prettySuggestions suggestions}
            '';
            locations = [
              (builtins.unsafeGetAttrPos argName drvArgs)
            ];
          }
        )
        unknownAttributeNames;
in
  checkMkDerivationFor checkDerivation final prev
