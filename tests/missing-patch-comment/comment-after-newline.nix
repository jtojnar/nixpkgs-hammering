{ stdenv
}:

stdenv.mkDerivation {
  name = "comment-after-newline";

  src = ../fixtures/make;

  patches = [
    "a"
    # comment after newline doesn't count
  ];
}
