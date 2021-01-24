{ builtAttrs
, packageSet
, namePositions
}@attrs:

final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkBuildPythonPackageFor;

  incorrectSpellings = [
    "pythonImportTests"
    "pythonImportCheck"
    "pythonImportsTest"
    "pythonCheckImports"
  ];

  checkDerivation = drvArgs: drv:
    (map
      (incorrectSpelling: {
        name = "python-imports-check-typo";
        cond = builtins.hasAttr incorrectSpelling drvArgs;
        msg = ''
          A typo in `pythonImportsCheck` was found.
        '';
        locations = [
          (builtins.unsafeGetAttrPos incorrectSpelling drvArgs)
        ];
      })
      incorrectSpellings
    );
in
  checkBuildPythonPackageFor checkDerivation attrs final prev
