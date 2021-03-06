[
  # TODO: move some of these into their proper place in derivation-attributes.nix

  # Qt
  "qtInputs"

  # Undocumented stdenv
  "preHook"
  "strictDeps"
  "hardeningDisable"
  "hardeningEnable"
  "dontAutoPatchelf"

  # Taken from stdenv.xml
  "depsBuildBuild"
  "depsBuildTarget"
  "depsHostHost"
  "depsTargetTarget"
  "depsBuildBuildPropagated"
  "depsBuildTargetPropagated"
  "depsHostHostPropagated"
  "depsTargetTargetPropagated"
  "NIX_DEBUG"
  "phases"
  "prePhases"
  "preConfigurePhases"
  "preBuildPhases"
  "preInstallPhases"
  "preFixupPhases"
  "preDistPhases"
  "postPhases"
  "sourceRoot"
  "setSourceRoot"
  "dontMakeSourcesWritable"
  "unpackCmd"
  "patchFlags"
  "configureScript"
  "configureFlagsArray"
  "dontAddPrefix"
  "prefix"
  "prefixKey"
  "dontAddDisableDepTrack"
  "dontFixLibtool"
  "dontDisableStatic"
  "configurePlatforms"
  "makefile"
  "makeFlagsArray"
  "installTargets"
  "dontStrip"
  "dontStripHost"
  "dontStripTarget"
  "dontMoveSbin"
  "stripAllList"
  "stripAllFlags"
  "stripDebugList"
  "stripDebugFlags"
  "dontPatchELF"
  "dontPatchShebangs"
  "dontPruneLibtoolFiles"
  "forceShare"
  "setupHook"
  "installCheckTarget"
  "distTarget"
  "distFlags"
  "tarballs"
  "dontCopyDist"
  "preDist"
  "postDist"

  # Multiple outputs
  "outputDev"
  "outputBin"
  "outputLib"
  "outputDoc"
  "outputDevdoc"
  "outputMan"
  "outputDevman"
  "outputInfo"

  # Nix derivation
  # https://nixos.org/manual/nix/unstable/expressions/advanced-attributes.html
  "allowedReferences"
  "allowedRequisites"
  "disallowedReferences"
  "disallowedRequisites"
  "exportReferencesGraph"
  "impureEnvVars"
  "outputHash"
  "outputHashAlgo"
  "outputHashMode"
  "passAsFile"
  "preferLocalBuild"
  "allowSubstitutes"
]
