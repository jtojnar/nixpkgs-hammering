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

  outputs = { self, flake-compat, nixpkgs, utils }: {
    overlays = {
      default =
        final:
        prev:

        {
          nixpkgs-hammering =
            prev.rustPlatform.buildRustPackage {
              pname = "nixpkgs-hammering";
              version = (prev.lib.importTOML ./Cargo.toml).package.version;
              src = ./.;

              cargoLock.lockFile = ./Cargo.lock;

              nativeBuildInputs = with prev; [
                makeWrapper
              ];

              passthru = {
                exePath = "/bin/nixpkgs-hammer";
              };

              postInstall = ''
                datadir="$out/share/nixpkgs-hammering"
                mkdir -p "$datadir"

                wrapProgram "$out/bin/nixpkgs-hammer" \
                    --prefix PATH ":" ${prev.lib.makeBinPath [
                      prev.nix
                    ]} \
                    --set OVERLAYS_DIR "$datadir/overlays"
                cp -r ${./overlays} "$datadir/overlays"
                cp -r ${./lib} "$datadir/lib"
              '';
            };
        };
    };
  } // utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
  in {
    packages = rec {
      default = nixpkgs-hammering;

      nixpkgs-hammering = (self.overlays.default pkgs pkgs).nixpkgs-hammering;
    };

    apps = rec {
      nixpkgs-hammer = utils.lib.mkApp {
        drv = self.packages.${system}.nixpkgs-hammering;
      };

      default = nixpkgs-hammer;
    };

    devShells = {
      default =
        pkgs.mkShell {
          buildInputs = with pkgs; [
            python3
            rustc
            cargo
            rust-analyzer
            rustfmt
          ];
        };

      # For legacy shell.nix
      nixpkgs-hammering =
        pkgs.mkShell {
          buildInputs = with pkgs; [
            self.packages.${system}.nixpkgs-hammering
          ];
        };
    };
  });
}
