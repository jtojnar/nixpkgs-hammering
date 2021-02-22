{ stdenv
, fetchpatch
}:

stdenv.mkDerivation {
  name = "comment-within";

  src = ../fixtures/make;

  patches = [
    (fetchpatch {
      # comment within
      url = ../fixtures/patch.patch;
      sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
    })
  ];
}
