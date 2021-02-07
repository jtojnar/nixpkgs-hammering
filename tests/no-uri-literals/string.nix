{ stdenv
}:

stdenv.mkDerivation {
  name = "no-uri-literals-string";

  src = ../fixtures/make;

  meta.homepage = "https://www.example.com";
}
