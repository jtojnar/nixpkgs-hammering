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
          A likely typo in the `${incorrectSpelling}` argument was found. Did you mean `pythonImportsCheck`?
        '';
        locations = [
          (builtins.unsafeGetAttrPos incorrectSpelling drvArgs)
        ];
      })
      incorrectSpellings
    );
in
  checkBuildPythonPackageFor checkDerivation final prev
