{ pkgs
}:

{
  # positive cases
  agpl3 = pkgs.callPackage ./agpl3.nix { };
  fdl11 = pkgs.callPackage ./fdl11.nix { };
  fdl12 = pkgs.callPackage ./fdl12.nix { };
  fdl13 = pkgs.callPackage ./fdl13.nix { };
  gpl1 = pkgs.callPackage ./gpl1.nix { };
  gpl2 = pkgs.callPackage ./gpl2.nix { };
  gpl3 = pkgs.callPackage ./gpl3.nix { };
  lgpl2 = pkgs.callPackage ./lgpl2.nix { };
  lgpl21 = pkgs.callPackage ./lgpl21.nix { };
  lgpl3 = pkgs.callPackage ./lgpl3.nix { };
  lgpl3-python = pkgs.python3.pkgs.callPackage ./lgpl3-python.nix { };

  # negative cases
  single-nonmatching-license = pkgs.callPackage ./single-nonmatching-license.nix { };
}
