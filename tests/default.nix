{ overlays ? []
, pkgs ? import (import ../default.nix).inputs.nixpkgs.outPath { inherit overlays; }
}:

{
  attribute-ordering = pkgs.recurseIntoAttrs (pkgs.callPackage ./attribute-ordering { });
  attribute-typo = pkgs.recurseIntoAttrs (pkgs.callPackage ./attribute-typo { });
  build-tools-in-build-inputs = pkgs.recurseIntoAttrs (pkgs.callPackage ./build-tools-in-build-inputs { });
  duplicate-check-inputs = pkgs.python3.pkgs.callPackage ./duplicate-check-inputs { };
  environment-variables-go-to-env = pkgs.recurseIntoAttrs (pkgs.callPackage ./environment-variables-go-to-env { });
  EvalError = pkgs.recurseIntoAttrs (pkgs.callPackage ./EvalError { });
  explicit-phases = pkgs.recurseIntoAttrs (pkgs.callPackage ./explicit-phases { });
  fixup-phase = pkgs.callPackage ./fixup-phase { };
  license-missing = pkgs.recurseIntoAttrs (pkgs.callPackage ./license-missing { });
  maintainers-missing = pkgs.recurseIntoAttrs (pkgs.callPackage ./maintainers-missing { });
  meson-cmake = pkgs.callPackage ./meson-cmake { };
  missing-patch-comment = pkgs.recurseIntoAttrs (pkgs.callPackage ./missing-patch-comment { });
  missing-phase-hooks = pkgs.recurseIntoAttrs (pkgs.callPackage ./missing-phase-hooks { });
  name-and-version = pkgs.recurseIntoAttrs (pkgs.callPackage ./name-and-version { });
  no-flags-array = pkgs.recurseIntoAttrs (pkgs.callPackage ./no-flags-array { });
  no-flags-spaces = pkgs.recurseIntoAttrs (pkgs.callPackage ./no-flags-spaces { });
  no-uri-literals = pkgs.recurseIntoAttrs (pkgs.callPackage ./no-uri-literals { });
  patch-phase = pkgs.callPackage ./patch-phase { };
  python-explicit-check-phase = pkgs.recurseIntoAttrs (pkgs.callPackage ./python-explicit-check-phase { });
  python-imports-check-typo = pkgs.recurseIntoAttrs (pkgs.callPackage ./python-imports-check-typo { });
  python-include-tests = pkgs.recurseIntoAttrs (pkgs.callPackage ./python-include-tests { });
  python-inconsistent-interpreters = pkgs.recurseIntoAttrs (pkgs.callPackage ./python-inconsistent-interpreters { });
  stale-substitute = pkgs.recurseIntoAttrs (pkgs.callPackage ./stale-substitute { });
  unclear-gpl = pkgs.recurseIntoAttrs (pkgs.callPackage ./unclear-gpl { });
  unnecessary-parallel-building = pkgs.recurseIntoAttrs (pkgs.callPackage ./unnecessary-parallel-building { });
  unused-argument = pkgs.recurseIntoAttrs (pkgs.callPackage ./unused-argument {});
}
