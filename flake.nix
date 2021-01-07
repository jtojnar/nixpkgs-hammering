{
  description = "Tool for pointing out issues in Nixpkgs packages";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-compat, nixpkgs, utils }: utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.nixpkgs-hammer = pkgs.runCommand "nixpkgs-hammer" {
      buildInputs = with pkgs; [
        python3
      ];
    } ''
      install -D ${./tools/nixpkgs-hammer} $out/bin/$name
      patchShebangs $out/bin/$name
      substituteInPlace $out/bin/$name \
        --replace "NIX_INSTANTIATE_PATH = 'nix-instantiate'" "NIX_INSTANTIATE_PATH = '${pkgs.nix}/bin/nix-instantiate'"
      ln -s ${./overlays} $out/overlays
      ln -s ${./lib} $out/lib
    '';

    defaultPackage = self.packages.${system}.nixpkgs-hammer;

    apps.nixpkgs-hammer = utils.lib.mkApp { drv = self.packages.${system}.nixpkgs-hammer; };

    defaultApp = self.apps.${system}.nixpkgs-hammer;
  });
}
