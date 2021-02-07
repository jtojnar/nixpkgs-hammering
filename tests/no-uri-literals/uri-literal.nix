{ stdenv
}:

stdenv.mkDerivation {
  name = "no-uri-literals-uri-literal";

  src = ../fixtures/make;

  meta.homepage = https://www.example.com;
}
