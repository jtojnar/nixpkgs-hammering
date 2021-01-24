{ overlays ? []
, pkgs ? import (import ../default.nix).inputs.nixpkgs.outPath { inherit overlays; }
}:

{
  attribute-ordering = pkgs.callPackage ./attribute-ordering { };
  build-tools-in-build-inputs = pkgs.recurseIntoAttrs (pkgs.callPackage ./build-tools-in-build-inputs { });
  duplicate-check-inputs = pkgs.python3.pkgs.callPackage ./duplicate-check-inputs { };
  explicit-phases = pkgs.callPackage ./explicit-phases { };
  fixup-phase = pkgs.callPackage ./fixup-phase { };
  meson-cmake = pkgs.callPackage ./meson-cmake { };
  missing-patch-comment = pkgs.callPackage ./missing-patch-comment { };
  missing-phase-hooks = pkgs.callPackage ./missing-phase-hooks { };
  patch-phase = pkgs.callPackage ./patch-phase { };
  python-explicit-check-phase = pkgs.python3.pkgs.callPackage ./python-explicit-check-phase { };
  python-imports-check-typo = pkgs.python3.pkgs.callPackage ./python-imports-check-typo { };
  python-include-tests = pkgs.python3.pkgs.callPackage ./python-include-tests { };
  python-inconsistent-interpreters = pkgs.python3.pkgs.callPackage ./python-inconsistent-interpreters { };
  unclear-gpl = pkgs.callPackage ./unclear-gpl { };
  unnecessary-parallel-building = pkgs.callPackage ./unnecessary-parallel-building { };
}
