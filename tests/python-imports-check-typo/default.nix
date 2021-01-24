{ callPackage
}:

{
  # positive cases
  pythonImportTests = callPackage ./pythonImportTests.nix { };
  pythonImportCheck = callPackage ./pythonImportCheck.nix { };
  pythonImportsTest = callPackage ./pythonImportsTest.nix { };
  pythonCheckImports = callPackage ./pythonCheckImports.nix { };

  # negative cases
  pythonImportsCheck = callPackage ./pythonImportsCheck.nix { };
}
