{ pkgs
}:

{
  # positive cases
  missing-comment = pkgs.callPackage ./missing-comment.nix { };

  # negative cases
  general-comment = pkgs.callPackage ./general-comment.nix { };
  comment-above = pkgs.callPackage ./comment-above.nix { };
  comment-within = pkgs.callPackage ./comment-within.nix { };
}
