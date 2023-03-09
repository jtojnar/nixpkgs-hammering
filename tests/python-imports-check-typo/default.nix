{
  python3,
}:

{
  # positive cases
  pythonImportTests = python3.pkgs.callPackage ./pythonImportTests.nix { };
  pythonImportCheck = python3.pkgs.callPackage ./pythonImportCheck.nix { };
  pythonImportsTest = python3.pkgs.callPackage ./pythonImportsTest.nix { };
  pythonCheckImports = python3.pkgs.callPackage ./pythonCheckImports.nix { };

  # negative cases
  pythonImportsCheck = python3.pkgs.callPackage ./pythonImportsCheck.nix { };
}
