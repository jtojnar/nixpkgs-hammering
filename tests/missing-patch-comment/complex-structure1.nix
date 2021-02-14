{ stdenv
, lib
, unrarSupport
}:

# From https://github.com/NixOS/nixpkgs/pull/113149
# https://github.com/jtojnar/nixpkgs-hammering/issues/23

stdenv.mkDerivation {
  name = "comments-in-complex-structure-1";

  src = ../fixtures/make;

  patches = [
    # Plugin installation (very insecure) disabled (from Debian)
    ./disable_plugins.patch
    # Automatic version update disabled by default (from Debian)
    ./no_updates_dialog.patch
  ]
  ++ lib.optional (!unrarSupport) ./dont_build_unrar_plugin.patch;
}
