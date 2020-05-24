{ pkgs ? import <nixpkgs> { }
}:

{
  nixpkgs-hammer = pkgs.runCommand "nixpkgs-hammer" { } ''
    install -D ${./tools/nixpkgs-hammer} $out/bin/$name
    patchShebangs $out/bin/$name
    ln -s ${./overlays} $out/overlays
  '';
}
