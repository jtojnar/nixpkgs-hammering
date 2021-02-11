[
  "name"
  "pname"
  "version"

  "outputs"

  "src"
  "srcs"
  "patches"

  {
    name = "lists of dependencies";
    values = [
      "nativeBuildInputs"
      "buildInputs"
      "propagatedNativeBuildInputs"
      "propagatedBuildInputs"
      "checkInputs"
      "installCheckInputs"
    ];
  }

  {
    name = "build system configuration flags";
    values = [
      "cmakeFlags"
      "mesonFlags"
      "configureFlags"
      "qmakeFlags"
    ];
  }

  {
    name = "build tool flags";
    values = [
      "makeFlags"
      "ninjaFlags"
      "buildFlags"
      "checkTarget"
      "checkFlags"
      "installFlags"
      "installCheckFlags"
      "enableParallelBuilding"
      "enableParallelChecking"
    ];
  }

  {
    name = "environment variables";
    values = [
      "CFLAGS"
      "CXXFLAGS"
      "FONTCONFIG_FILE"
      "NIX_CFLAGS_COMPILE"
      "NIX_CFLAGS_LINK"
      "NIX_ENFORCE_NO_NATIVE"
      "NIX_LDFLAGS"
    ];
  }

  {
    name = "attributes for enabling off-by-default phases";
    values = [
      "doCheck"
      "doInstallCheck"
      "doDist"
    ];
  }
  
  {
    name = "attributes for disabling on-by-default phases";
    values = [
      "dontUnpack"
      "dontPatch"
      "dontConfigure"
      "dontBuild"
      "dontUseNinjaBuild"
      "dontInstall"
      "dontUseNinjaInstall"
      "dontFixup"
      "dontUseNinjaCheck"
    ];
  }

  {
    name = "attributes for overriding default phases";
    values = [
      "preUnpack"
      "unpackPhase"
      "postUnpack"
      "prePatch"
      "patchPhase"
      "postPatch"
      # "preConfigurePhases"
      "preConfigure"
      "configurePhase"
      "postConfigure"
      # "preBuildPhases"
      "preBuild"
      "buildPhase"
      "postBuild"
      "preCheck"
      "checkPhase"
      "postCheck"
      # "preInstallPhases"
      "preInstall"
      "installPhase"
      "postInstall"
      # "preFixupPhases"
      "preFixup"
      "fixupOutput"
      "fixupPhase"
      "postFixup"
      "preInstallCheck"
      "installCheckPhase"
      "postInstallCheck"
      # "preDistPhases"
      "distPhase"
      # "postPhases"
    ];
  }

  "passthru"
  "meta"
]
