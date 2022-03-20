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

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-compat, naersk, nixpkgs, utils }: {
    overlay = final: prev: {
      nixpkgs-hammering =
        let
          naersk-lib = prev.callPackage naersk {};

          rust-checks = naersk-lib.buildPackage {
            name = "rust-checks";
            root = ./rust-checks;
          };

          # Find all of the binaries installed by rust-checks. Note, if this changes
          # in the future to use wrappers or something else that pollute the bin/
          # directory, this logic will have to grow.
          rust-check-names = let
            binContents = builtins.readDir "${rust-checks}/bin";
          in
            prev.lib.mapAttrsToList (name: type: assert type == "regular"; name) binContents;
        in
          prev.runCommand "nixpkgs-hammering" {
            buildInputs = with prev; [
              python3
              makeWrapper
            ];

            passthru = {
              inherit rust-checks;
              exePath = "/bin/nixpkgs-hammer";
            };
          } ''
            install -D ${./tools/nixpkgs-hammer} $out/bin/nixpkgs-hammer
            patchShebangs $out/bin/nixpkgs-hammer

            wrapProgram "$out/bin/nixpkgs-hammer" \
                --prefix PATH ":" ${prev.lib.makeBinPath [
                  prev.nixVersions.stable or prev.nixUnstable
                  rust-checks
                ]} \
                --set AST_CHECK_NAMES ${prev.lib.concatStringsSep ":" rust-check-names}
            ln -s ${./overlays} $out/overlays
            ln -s ${./lib} $out/lib
          '';
    };
  } // utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
  in rec {
    packages.nixpkgs-hammering = (self.overlay pkgs pkgs).nixpkgs-hammering;

    defaultPackage = self.packages.${system}.nixpkgs-hammering;

    apps.nixpkgs-hammer = utils.lib.mkApp { drv = self.packages.${system}.nixpkgs-hammering; };

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
