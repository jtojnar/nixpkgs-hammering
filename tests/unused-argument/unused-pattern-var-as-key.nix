{ stdenv
, unused
}:

stdenv.mkDerivation {
  name = "unused-pattern";

  src = ../fixtures/make;

  # although we have the identifier 'unused' in the function body
  # this does not count as usage for purposes of 'unused-argument'
  # because of it's position as a key in an attrset
  unused = 1;
}
