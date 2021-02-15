{ pkgs }:

{
  # positive cases
  unused-pattern = pkgs.callPackage ./unused-pattern.nix { };
  unused-pattern-var-as-key = pkgs.callPackage ./unused-pattern-var-as-key.nix { };
  unused-pattern-var-in-let-binding = pkgs.callPackage ./unused-pattern-var-in-let-binding.nix { };

  # negative cases
  used-pattern = pkgs.callPackage ./used-pattern.nix {
    var1 = 1;
    var2 = 2;
  };
  used-single = pkgs.callPackage ./used-single.nix { };
  unused-single = pkgs.callPackage ./unused-single.nix { };
  used-in-string1 = pkgs.callPackage ./used-in-string1.nix { foo = "bar"; };
  used-in-string2 = pkgs.callPackage ./used-in-string2.nix { foo = "bar"; };
  used-in-defaults = pkgs.callPackage ./used-in-defaults.nix { };
}
