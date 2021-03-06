final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  buildTools = [
    "antlr"
    "asciidoc"
    "asciidoctor"
    "autoconf"
    "autogen"
    "automake"
    "automoc4"
    "autoreconfHook"
    "bazel"
    "bc"
    "bdf2psf"
    "bison"
    "bmake"
    "breakpointHook"
    "bzip2"
    "bundler"
    "cmake"
    "docutils"
    "dos2unix"
    "desktop-file-utils"
    "docbook2x"
    "docbook_xml_dtd_412"
    "docbook_xml_dtd_42"
    "docbook_xml_dtd_43"
    "docbook_xml_dtd_44"
    "docbook_xml_dtd_45"
    "docbook-xsl-nons"
    "docbook-xsl-ns"
    "doxygen"
    "ensureNewerSourcesForZipFilesHook"
    "extra-cmake-modules"
    "flex"
    "gawk"
    "gcc"
    "gcc10"
    "getopt"
    "git"
    "gnum4"
    "gnumake"
    "gnused"
    "gnustep.make"
    "gogUnpackHook"
    "go-md2man"
    "gtk-doc"
    "gzip"
    "help2man"
    "intltool"
    "libtool"
    "lit"
    "lld"
    "llvm"
    "makeWrapper"
    "man"
    "maven"
    "meson"
    "ninja"
    "nodePackages.node-gyp"
    "nodePackages.node-gyp-build"
    "nodePackages.node-pre-gyp"
    "pandoc"
    "patch"
    "patchelf"
    "pkg-config"
    "poetry"
    "qmake4Hook"
    "qt5.wrapQtAppsHook"
    "ronn"
    "rpcsvc-proto"
    "rpm"
    "rpmextract"
    "rsync"
    "python2.pkgs.setuptools-git"
    "python3.pkgs.setuptools-git"
    "python2.pkgs.setuptools-scm"
    "python3.pkgs.setuptools-scm"
    "python2.pkgs.setuptools-scm-git-archive"
    "python3.pkgs.setuptools-scm-git-archive"
    "python2.pkgs.sphinx"
    "python3.pkgs.sphinx"
    "python2.pkgs.wrapPython"
    "python3.pkgs.wrapPython"
    "squashfsTools"
    "sudo"
    "subversion"
    "swig"
    "unzip"
    "updateAutotoolsGnuConfigScriptsHook"
    "util-linux"
    "vala"
    "wafHook"
    "which"
    "wrapGAppsHook"
    "xcbuildHook"
    "xcodebuild"
    "xmlto"
    "xvfb_run"
    "yacc"
    "yarn"
    "zip"
  ] ++ lib.optionals (prev.stdenv.isDarwin) [
    "darwin.cctools"
  ];

  checkDerivation = drvArgs: drv:
    (map
      (tool: {
        name = "build-tools-in-build-inputs";
        cond = lib.elem (lib.attrByPath (lib.splitString "." tool) (throw "‘${tool}’ does not exist in Nixpkgs.") prev) (drvArgs.buildInputs or [ ]);
        msg = ''
          ${tool} is a build tool so it likely goes to `nativeBuildInputs`, not `buildInputs`.
        '';
        locations = [
          (builtins.unsafeGetAttrPos "buildInputs" drvArgs)
        ];
      })
      buildTools
    );

in
  checkMkDerivationFor checkDerivation final prev
