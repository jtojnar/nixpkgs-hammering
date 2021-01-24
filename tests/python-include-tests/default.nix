{ callPackage
}:

{
  # positive cases
  no-tests-no-import-checks = callPackage ./no-tests-no-import-checks.nix { };
  tests-disabled-no-import-checks = callPackage ./tests-disabled-no-import-checks.nix { };

  # negative cases
  pytest-check-hook = callPackage ./pytest-check-hook.nix { };
  explicit-check-phase = callPackage ./explicit-check-phase.nix { };
  has-imports-check = callPackage ./has-imports-check.nix { };
}
