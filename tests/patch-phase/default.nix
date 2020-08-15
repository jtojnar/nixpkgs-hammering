{ stdenv
}:

stdenv.mkDerivation {
  name = "patch-phase";

  src = ../fixtures/make;

  patchPhase = ''
    sed -i 's/o/e/g' foo.in
  '';
}
