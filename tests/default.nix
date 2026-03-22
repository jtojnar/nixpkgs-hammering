{
  overlays ? [ ],
  pkgs ? import (import ../default.nix).inputs.nixpkgs.outPath { inherit overlays; },
  lib ? pkgs.lib,
}:

{
  attribute-ordering = lib.recurseIntoAttrs (pkgs.callPackage ./attribute-ordering { });
  attribute-typo = lib.recurseIntoAttrs (pkgs.callPackage ./attribute-typo { });
  build-tools-in-build-inputs = lib.recurseIntoAttrs (pkgs.callPackage ./build-tools-in-build-inputs { });
  duplicate-check-inputs = pkgs.python3.pkgs.callPackage ./duplicate-check-inputs { };
  environment-variables-go-to-env = lib.recurseIntoAttrs (pkgs.callPackage ./environment-variables-go-to-env { });
  EvalError = lib.recurseIntoAttrs (pkgs.callPackage ./EvalError { });
  explicit-phases = lib.recurseIntoAttrs (pkgs.callPackage ./explicit-phases { });
  fixup-phase = pkgs.callPackage ./fixup-phase { };
  license-missing = lib.recurseIntoAttrs (pkgs.callPackage ./license-missing { });
  maintainers-missing = lib.recurseIntoAttrs (pkgs.callPackage ./maintainers-missing { });
  meson-cmake = pkgs.callPackage ./meson-cmake { };
  missing-patch-comment = lib.recurseIntoAttrs (pkgs.callPackage ./missing-patch-comment { });
  missing-phase-hooks = lib.recurseIntoAttrs (pkgs.callPackage ./missing-phase-hooks { });
  name-and-version = lib.recurseIntoAttrs (pkgs.callPackage ./name-and-version { });
  no-flags-array = lib.recurseIntoAttrs (pkgs.callPackage ./no-flags-array { });
  no-flags-spaces = lib.recurseIntoAttrs (pkgs.callPackage ./no-flags-spaces { });
  no-uri-literals = lib.recurseIntoAttrs (pkgs.callPackage ./no-uri-literals { });
  patch-phase = pkgs.callPackage ./patch-phase { };
  python-explicit-check-phase = lib.recurseIntoAttrs (pkgs.callPackage ./python-explicit-check-phase { });
  python-imports-check-typo = lib.recurseIntoAttrs (pkgs.callPackage ./python-imports-check-typo { });
  python-include-tests = lib.recurseIntoAttrs (pkgs.callPackage ./python-include-tests { });
  python-inconsistent-interpreters = lib.recurseIntoAttrs (pkgs.callPackage ./python-inconsistent-interpreters { });
  stale-substitute = lib.recurseIntoAttrs (pkgs.callPackage ./stale-substitute { });
  unclear-gpl = lib.recurseIntoAttrs (pkgs.callPackage ./unclear-gpl { });
  unnecessary-parallel-building = lib.recurseIntoAttrs (pkgs.callPackage ./unnecessary-parallel-building { });
  unused-argument = lib.recurseIntoAttrs (pkgs.callPackage ./unused-argument { });
}
