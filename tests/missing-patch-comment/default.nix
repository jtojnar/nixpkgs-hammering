{ pkgs
}:

{
  # positive cases
  missing-comment = pkgs.callPackage ./missing-comment.nix { };
  comment-after-newline = pkgs.callPackage ./comment-after-newline.nix { };

  # negative cases
  general-comment = pkgs.callPackage ./general-comment.nix { };
  comment-above = pkgs.callPackage ./comment-above.nix { };
  comment-within = pkgs.callPackage ./comment-within.nix { };
  comment-inline = pkgs.callPackage ./comment-inline.nix { };
  complex-structure1 = pkgs.callPackage ./complex-structure1.nix {
    unrarSupport = true;
  };
  ignore-nested-lists1 = pkgs.callPackage ./ignore-nested-lists1.nix { };
  ignore-nested-lists2 = pkgs.callPackage ./ignore-nested-lists2.nix { };
}
