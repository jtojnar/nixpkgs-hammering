{
  description = "Tool for pointing out issues in Nixpkgs packages";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.nixpkgs-hammer = pkgs.runCommand "nixpkgs-hammer" { } ''
      install -D ${./tools/nixpkgs-hammer} $out/bin/$name
      patchShebangs $out/bin/$name
      ln -s ${./overlays} $out/overlays
      ln -s ${./lib} $out/lib
    '';

    defaultPackage = self.packages.${system}.nixpkgs-hammer;

    apps.nixpkgs-hammer = utils.lib.mkApp { drv = self.packages.${system}.nixpkgs-hammer; };

    defaultApp = self.apps.${system}.nixpkgs-hammer;
  });
}
