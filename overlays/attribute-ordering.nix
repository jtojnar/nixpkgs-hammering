final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkFor;

  preferredOrdering =
    let
      flattenGroup = item:
        if builtins.isAttrs item then
          map (subitem: { group = item.name; attr = subitem; }) item.values
        else
          [ { attr = item; } ];
      addOrder = n: i: i // { order = n; };
    in
      lib.pipe (import ../lib/derivation-attributes.nix) [
        (builtins.concatMap flattenGroup)
        (lib.imap0 addOrder)
        (builtins.map ({ attr, order, group ? null }@attrs: {
          name = attr;
          value = { inherit order group; };
        }))
        builtins.listToAttrs
      ];

  checkDerivation = drvArgs: drv:
    let
      getAttrPos = attr: (builtins.unsafeGetAttrPos attr drvArgs);
      getAttrLine = attr: (getAttrPos attr).line;

      drvAttrs = lib.pipe drvArgs [
        builtins.attrNames
        # Certain functions like mapAttrs can produce attributes without associated position.
        (builtins.filter (attr: getAttrPos attr != null))
        (builtins.sort (a: b: getAttrLine a < getAttrLine b))
      ];

      knownDrvAttrs = builtins.filter (attr: preferredOrdering ? "${attr}") drvAttrs;

      sideBySide = lib.zipLists knownDrvAttrs (builtins.tail knownDrvAttrs);
    in
      lib.forEach sideBySide ({ fst, snd }:
        let
          fstInfo = preferredOrdering.${fst};
          sndInfo = preferredOrdering.${snd};
          sameGroup = fstInfo.group == sndInfo.group;
        in {
          name = "attribute-ordering";
          cond =
            fstInfo.order > sndInfo.order &&
            # Inherited attributes all have the same position so sort will keep them in alphabetical order returned by attrNames.
            # This means we will not be able to detect if they are out of order and have to skip them.
            getAttrPos fst != getAttrPos snd;
          msg = ''
            The ${lib.optionalString (sndInfo.group != null && !sameGroup) "${sndInfo.group}, including the "}attribute “${snd}” should preferably come before ${lib.optionalString (fstInfo.group != null && !sameGroup) "${fstInfo.group}’ "}“${fst}” attribute ${lib.optionalString (sndInfo.group != null && sameGroup) "among ${sndInfo.group} "}in the expression.
          '';
          locations = [
            (builtins.unsafeGetAttrPos fst drvArgs)
            (builtins.unsafeGetAttrPos snd drvArgs)
          ];
        }
      );

in
  checkFor checkDerivation final prev
