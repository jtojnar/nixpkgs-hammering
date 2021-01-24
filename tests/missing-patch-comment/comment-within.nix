{ stdenv
, fetchpatch
}:

stdenv.mkDerivation {
  name = "comment-within";

  src = ../fixtures/make;

  patches = [
    (fetchpatch {
      # comment within
      url = "bla-bla-bla";
    })
  ];
}
