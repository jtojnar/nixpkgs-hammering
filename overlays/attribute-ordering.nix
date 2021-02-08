{ builtAttrs
, packageSet
, namePositions
}@attrs:

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
      getAttrLine = attr: (builtins.unsafeGetAttrPos attr drvArgs).line;

      drvAttrs = builtins.sort (a: b: getAttrLine a < getAttrLine b) (builtins.attrNames drvArgs);

      knownDrvAttrs = builtins.filter (attr: preferredOrdering ? "${attr}") drvAttrs;

      sideBySide = lib.zipLists knownDrvAttrs (builtins.tail knownDrvAttrs);
    in
      lib.forEach sideBySide ({ fst, snd }:
        let
          fstInfo = preferredOrdering.${fst};
          sndInfo = preferredOrdering.${snd};
        in {
          name = "attribute-ordering";
          cond = fstInfo.order > sndInfo.order;
          msg = ''
            The ${lib.optionalString (sndInfo.group != null) "${sndInfo.group}, including the "}attribute “${snd}” should preferably come before ${lib.optionalString (fstInfo.group != null) "${fstInfo.group}’ "}“${fst}” attribute in the expression.
          '';
          locations = [
            (builtins.unsafeGetAttrPos fst drvArgs)
            (builtins.unsafeGetAttrPos snd drvArgs)
          ];
        }
      );

in
  checkFor checkDerivation attrs final prev
