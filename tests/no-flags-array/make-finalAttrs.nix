{ stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  name = "no-flags-array-make";

  src = ../fixtures/make;

  makeFlagsArray = [
    "PREFIX=${placeholder "out"}"
    "LIBDIR=${placeholder "out"}/lib"
  ];
})
