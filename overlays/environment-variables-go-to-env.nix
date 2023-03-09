final:
prev:

let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  knownEnvironmentVariables = import ../lib/environment-variables.nix;

  isEnvironmentVariable =
    name:
    builtins.elem name knownEnvironmentVariables
    || lib.hasPrefix "PKG_CONFIG_" name;

  checkDerivation = drvArgs: drv:
    let
      environmentVariables = builtins.filter isEnvironmentVariable (builtins.attrNames drvArgs);
    in
    builtins.map
      (var:
        {
          name = "environment-variables-go-to-env";
          cond = builtins.length environmentVariables > 0;
          msg = ''
            Environment variable `${var}` should be moved to `env` attribute rather than being passed directly to ‘stdenv.mkDerivation’.
          '';
          locations = [
            (builtins.unsafeGetAttrPos var drvArgs)
          ];
        }
      )
      environmentVariables;
in
checkMkDerivationFor checkDerivation final prev
