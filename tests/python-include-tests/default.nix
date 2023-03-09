{
  python3,
}:

{
  # positive cases
  no-tests-no-import-checks = python3.pkgs.callPackage ./no-tests-no-import-checks.nix { };
  tests-disabled-no-import-checks = python3.pkgs.callPackage ./tests-disabled-no-import-checks.nix { };

  # negative cases
  pytest-check-hook = python3.pkgs.callPackage ./pytest-check-hook.nix { };
  explicit-check-phase = python3.pkgs.callPackage ./explicit-check-phase.nix { };
  has-imports-check = python3.pkgs.callPackage ./has-imports-check.nix { };
}
