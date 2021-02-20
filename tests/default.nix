{ overlays ? []
, pkgs ? import (import ../default.nix).inputs.nixpkgs.outPath { inherit overlays; }
}:

{
  attribute-ordering = pkgs.callPackage ./attribute-ordering { };
  attribute-typo = pkgs.callPackage ./attribute-typo { };
  build-tools-in-build-inputs = pkgs.recurseIntoAttrs (pkgs.callPackage ./build-tools-in-build-inputs { });
  duplicate-check-inputs = pkgs.python3.pkgs.callPackage ./duplicate-check-inputs { };
  EvalError = pkgs.callPackage ./EvalError { };
  explicit-phases = pkgs.callPackage ./explicit-phases { };
  fixup-phase = pkgs.callPackage ./fixup-phase { };
  license-missing = pkgs.callPackage ./license-missing { };
  maintainers-missing = pkgs.callPackage ./maintainers-missing { };
  meson-cmake = pkgs.callPackage ./meson-cmake { };
  missing-patch-comment = pkgs.callPackage ./missing-patch-comment { };
  missing-phase-hooks = pkgs.callPackage ./missing-phase-hooks { };
  no-flags-array = pkgs.callPackage ./no-flags-array { };
  no-flags-spaces = pkgs.callPackage ./no-flags-spaces { };
  no-python-tests = pkgs.python3.pkgs.callPackage ./no-python-tests { };
  no-uri-literals = pkgs.callPackage ./no-uri-literals { };
  patch-phase = pkgs.callPackage ./patch-phase { };
  python-explicit-check-phase = pkgs.python3.pkgs.callPackage ./python-explicit-check-phase { };
  python-imports-check-typo = pkgs.python3.pkgs.callPackage ./python-imports-check-typo { };
  python-include-tests = pkgs.python3.pkgs.callPackage ./python-include-tests { };
  python-inconsistent-interpreters = pkgs.python3.pkgs.callPackage ./python-inconsistent-interpreters { };
  stale-substitute = pkgs.callPackage ./stale-substitute { };
  unclear-gpl = pkgs.callPackage ./unclear-gpl { };
  unnecessary-parallel-building = pkgs.callPackage ./unnecessary-parallel-building { };
  unused-argument = pkgs.callPackage ./unused-argument {};
}
