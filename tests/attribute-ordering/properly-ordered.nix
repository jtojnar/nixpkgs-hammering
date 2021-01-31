{ stdenv
, lib
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "properly-ordered";
  version = "0.0.0";

  outputs = [ "out" ];

  src = ../fixtures/make;

  patches = [
  ];

  nativeBuildInputs = [
  ];

  buildInputs = [ 
  ];

  propagatedNativeBuildInputs = [
  ];

  propagatedBuildInputs = [
  ];

  checkInputs = [
  ];

  installCheckInputs = [
  ];

  configureFlags = [
  ];
  
  makeFlags = [
  ];

  buildFlags = [
  ];

  installFlags = [
  ];

  FONTCONFIG_FILE = "";
  NIX_CFLAGS_COMPILE = "";

  doCheck = true;
  doInstallCheck = true;
  
  dontBuild = true;

  preUnpack = "";
  unpackPhase = null;
  postUnpack = "";
  prePatch = "";
  patchPhase = null;
  postPatch = "";
  preConfigure = "";
  configurePhase = null;
  postConfigure = "";
  preBuild = "";
  buildPhase = null;
  postBuild = "";
  preCheck = "";
  checkPhase = null;
  postCheck = "";
  preInstall = "";
  installPhase = null;
  postInstall = "";
  preFixup = "";
  fixupOutput = "";
  fixupPhase = null;
  postFixup = "";
  preInstallCheck = "";
  installCheckPhase = null;
  postInstallCheck = "";

  passthru = { };

  meta = with lib; {
    description = "";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [];
  };
}
