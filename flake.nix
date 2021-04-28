{
  description = "Tool for pointing out issues in Nixpkgs packages";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    traceFd = {
      url = "github:rmcgibbo/nix-traceFd/master";
      flake = false;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-compat, naersk, nixpkgs, utils, traceFd }: utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
    naersk-lib = naersk.lib."${system}";
  in rec {

    traceFdBuilt = pkgs.callPackage traceFd {};

    packages.rust-checks = naersk-lib.buildPackage {
      name = "rust-checks";
      root = ./rust-checks;
    };

    packages.nixpkgs-hammer =
      let
        # Find all of the binaries installed by rust-checks. Note, if this changes
        # in the future to use wrappers or something else that pollute the bin/
        # directory, this logic will have to grow.
        rust-check-names = let
          binContents = builtins.readDir "${packages.rust-checks}/bin";
        in
          pkgs.lib.mapAttrsToList (name: type: assert type == "regular"; name) binContents;
      in
        pkgs.runCommand "nixpkgs-hammer" {
          buildInputs = with pkgs; [
            python3
            makeWrapper
          ];
        } ''
          install -D ${./tools/nixpkgs-hammer} $out/bin/$name
          patchShebangs $out/bin/$name

          wrapProgram "$out/bin/$name" \
              --prefix PATH ":" ${pkgs.lib.makeBinPath [
                pkgs.nixUnstable
                packages.rust-checks
              ]} \
              --set AST_CHECK_NAMES ${pkgs.lib.concatStringsSep ":" rust-check-names} \
              --set NIX_PLUGINS ${traceFdBuilt}/lib/nix/plugins/libtraceFd.so
          ln -s ${./overlays} $out/overlays
          ln -s ${./lib} $out/lib
        '';

    defaultPackage = self.packages.${system}.nixpkgs-hammer;

    apps.nixpkgs-hammer = utils.lib.mkApp { drv = self.packages.${system}.nixpkgs-hammer; };

    defaultApp = self.apps.${system}.nixpkgs-hammer;

    devShell = pkgs.mkShell {
      buildInputs = with pkgs; [
        python3
        rustc
        cargo
      ];
    };
  });
}
