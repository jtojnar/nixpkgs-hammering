final: prev:
let
  inherit (prev) lib;
  inherit (import ../lib { inherit lib; }) checkMkDerivationFor;

  buildToolAttrs = [
    "antlr"
    "asciidoc"
    "asciidoctor"
    "autoconf"
    "autogen"
    "automake"
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
    "getopt"
    "git"
    "gnum4"
    "gnumake"
    "gnused"
    "gnustep-make"
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
    "node-gyp"
    "node-pre-gyp"
    "nodePackages.node-gyp-build"
    "pandoc"
    "patch"
    "patchelf"
    "pkg-config"
    "poetry"
    "qt5.wrapQtAppsHook"
    "ronn"
    "rpcsvc-proto"
    "rpm"
    "rpmextract"
    "rsync"
    "python3.pkgs.setuptools-git"
    "python3.pkgs.setuptools-scm"
    "python3.pkgs.sphinx"
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
    "wrapGAppsHook3"
    "wrapGAppsHook4"
    "wrapGAppsNoGuiHook"
    "xcbuildHook"
    "xcodebuild"
    "xmlto"
    "xvfb-run"
    "yarn"
    "zip"
  ] ++ lib.optionals (prev.stdenv.isDarwin) [
    "darwin.cctools"
  ];

  developmentMode = builtins.getEnv "NIXPKGS_HAMMERING_FATAL_EVAL_ISSUES" != "";

  mkTool =
    attrPath:
    let
      package = lib.attrByPath (lib.splitString "." attrPath) null prev;
    in
    if !(builtins.tryEval package).success then
      if developmentMode then throw "‘${attrPath}’ is a ‘throw \"...\"’ in Nixpkgs." else null
    else if package == null then
      if developmentMode then throw "‘${attrPath}’ does not exist in Nixpkgs." else null
    else if package.meta.broken or false then
      if developmentMode then throw "‘${attrPath}’ is broken in Nixpkgs." else null
    else
      {
        name = attrPath;
        inherit package;
      };

  buildTools = builtins.filter (tool: tool != null) (builtins.map mkTool buildToolAttrs);

  checkDerivation = drvArgs: drv:
    (map
      (tool: {
        name = "build-tools-in-build-inputs";
        cond = lib.elem tool.package (drvArgs.buildInputs or [ ]);
        msg = ''
          ${tool.name} is a build tool so it likely goes to `nativeBuildInputs`, not `buildInputs`.
        '';
        locations = [
          (builtins.unsafeGetAttrPos "buildInputs" drvArgs)
        ];
      })
      buildTools
    );

in
  checkMkDerivationFor checkDerivation final prev
