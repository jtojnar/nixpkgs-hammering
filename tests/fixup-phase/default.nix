{ stdenv
}:

stdenv.mkDerivation {
  name = "fixup-phase";

  src = ../fixtures/make;

  fixupPhase = ''
    sed -i 's/o/e/g' $out/foo
  '';
}
