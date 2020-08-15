If you are overriding `configurePhase`, `buildPhase`, `checkPhase`, `installPhase` or any other phase, you should not forget about running pre and post-phase hooks like [their](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/stdenv/generic/setup.sh#L953) [original](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/stdenv/generic/setup.sh#L1008) [definitions](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/stdenv/generic/setup.sh#L1037) [do](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/stdenv/generic/setup.sh#L1078).

Many setup hooks make use of these hooks and not running them can also confuse developers adding hooks to the package.

### Before
```nix
  installPhase = ''
    your commands
  '';
```

### After
```nix
  installPhase = ''
    runHook preInstall

    your commands

    runHook postInstall
  '';
```

And if you just want to add a flag to `make` call, you might not even need to override the phases, see [`explicit-phases`](explicit-phases.md) rule.
