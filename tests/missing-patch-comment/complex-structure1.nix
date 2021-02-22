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
    ../fixtures/patch.patch
  ]
  ++ lib.optional (!unrarSupport) ./foobar.patch;
}
