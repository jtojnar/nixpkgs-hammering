# Set of functions depending just on builtins,
# to be shared between the checks and the tool.
{
  # Get location of the source code of a derivation.
  # This is roughly equivalent to `meta.position` used by nix edit.
  getDrvSourceLocation = drv:
    let
      pnamePosition = builtins.unsafeGetAttrPos "pname" drv;
    in
      if pnamePosition != null then
        pnamePosition
      else
        builtins.unsafeGetAttrPos "name" drv;
}
