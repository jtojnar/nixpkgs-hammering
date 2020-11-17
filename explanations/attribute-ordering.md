Many nixpkgs maintainers like having consistent ordering so we can quickly locate things we need to change. This is nothing but a personal preference but [growing stronger](https://discourse.nixos.org/t/document-attribute-ordering-in-package-expressions/4887).

We start with general package information and sources that change every update, then list dependencies, set up build, potentially override the default builder phases and finally provide metadata. This is sort of high level to low level ordering but not exactly.

## Examples
```nix
{ stdenv 
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "";
  version = "";

  # Outputs are also part of store paths.
  outputs = [ ];

  src = fetchurl {
    url = "";
    sha256 = "";
  };

  # Patches often depend on source code and need to be kept in sync.
  patches = [
  ];

  # Dependencies. Build-time dependencies (native) first, then regular, then propagated variants of the two, then dependencies for tests.
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

  # Build systemd configuration flags.
  configureFlags = [
  ];
  # or cmakeFlags, mesonFlags
  
  # Build tool flags common for all phases.
  makeFlags = [
  ];
  # or ninjaFlags

  # 
  buildFlags = [
  ];

  installFlags = [
  ];

  # Environment variables.
  FONTCONFIG_FILE = "";
  NIX_CFLAGS_COMPILE = "";

  # Enabling off-by-default phases.
  doCheck = true;
  doInstallCheck = true;
  
  # Disabling on-by-default phases.
  dontBuild = true;

  # Attributes for overriding default phases, and their hooks should be ordered exactly as they are executed in setup.sh (https://github.com/NixOS/nixpkgs/blob/18f47ecbac1066b388e11dfa12617b557abeaf66/pkgs/stdenv/generic/setup.sh#L1261).
  # preUnpack
  # unpackPhase
  # postUnpack
  # prePatch
  # patchPhase
  # postPatch
  # preConfigure
  # configurePhase
  # postConfigure
  # preBuild
  # buildPhase
  # postBuild
  # preCheck
  # checkPhase
  # postCheck
  # preInstall
  # installPhase
  # postInstall
  # preFixup
  # fixupOutput
  # fixupPhase
  # postFixup
  # preInstallCheck
  # installCheckPhase
  # postInstallCheck

  # Metadata
  passthru = {
  };

  meta = with stdenv.lib; {
    description = "";
    longDescription = ''
    '';
    homepage = "";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      somebody
    ];
  };
}
```
