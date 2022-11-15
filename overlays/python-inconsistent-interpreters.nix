final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkBuildPythonPackageFor;

  checkDerivation = drvArgs: drv:
    let
      propagatedBuildInputs = drvArgs.propagatedBuildInputs or [];
      checkInputs = drvArgs.checkInputs or [];
      runtimeInputs = checkInputs ++ propagatedBuildInputs;
      inputPythonInterpreters = map (p: p.pythonModule) (builtins.filter (p: p ? pythonModule) runtimeInputs);
      allPythonInterpreters = lib.unique (inputPythonInterpreters ++ lib.optionals (drv ? pythonModule) [ drv.pythonModule ]);
    in
      lib.singleton {
        name = "python-inconsistent-interpreters";
        cond = builtins.length allPythonInterpreters > 1;
        msg =
          let
            allPythonNames = map (p: p.name) allPythonInterpreters;
            sources = if drv ? pythonModule
            then [ "buildPythonPackage"
            ] ++ lib.optionals (builtins.any (p: p.pythonModule or drv.pythonModule != drv.pythonModule) propagatedBuildInputs) [
              "propagatedBuildInputs"
            ] ++ lib.optionals (builtins.any (p: p.pythonModule or drv.pythonModule != drv.pythonModule) checkInputs) [
              "checkInputs"
            ]
            else [ "buildPythonApplication"
            ] ++ lib.optionals (builtins.length (lib.unique(map (p: p.pythonModule) propagatedBuildInputs)) >= 2) [
              "propagatedBuildInputs"
            ] ++ lib.optionals (builtins.length (lib.unique(map (p: p.pythonModule) checkInputs)) >= 2) [
              "checkInputs"
            ];

          in ''
            Between ${lib.concatStringsSep " and " sources}, this derivation seems
            to be simultaneously trying to use packages from multiple different Python package sets.
            Mixing package sets like this is not supported.

            Detected Python packages:

            ${lib.concatMapStringsSep "\n" (p: "- ${p}") allPythonNames}
          '';
      };
in
  checkBuildPythonPackageFor checkDerivation final prev
