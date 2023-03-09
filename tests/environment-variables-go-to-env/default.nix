{
  pkgs,
}:

{
  # positive cases
  env-var = pkgs.callPackage ./env-var.nix { };
  pkg-config-var = pkgs.callPackage ./pkg-config-var.nix { };

  # negative cases
  env-vars-just-in-env = pkgs.callPackage ./env-vars-just-in-env.nix { };
  no-env-vars = pkgs.callPackage ./no-env-vars.nix { };
}
