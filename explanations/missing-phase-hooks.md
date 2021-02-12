If you are overriding `configurePhase`, `buildPhase`, `checkPhase`, `installPhase` or any other phase, you should not forget about explicitly running pre and post-phase hooks like [their](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/stdenv/generic/setup.sh#L953) [original](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/stdenv/generic/setup.sh#L1008) [definitions](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/stdenv/generic/setup.sh#L1037) [do](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/stdenv/generic/setup.sh#L1078).

It is generally expected that an appropriate pre-phase hook (e.g. `preBuild`) hook will run at the beginning of a phase (e.g. `buildPhase`) and post-phase hook (e.g. `postBuild`) will run at the end. Hooks are normally ran as a part of a phase so if you override a phase as a whole, you will need to add `runHook hookName` calls (e.g. `runHook preBuild`) manually.

Having phases run pre/post-phase hooks is important because many setup hooks insert their own code into them – omitting a hook might therefore prevent some setup hooks required for proper functionality of a package from running. Additionally, hooks are often inserted by developers into the package expression and by users when overriding a package using `overrideAttrs`. Not running them can thus cause confusion why their code is not executed.


## Examples
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

## Alternatives
And if you just want to add a flag to `make` call, you might not even need to override the phases, see [`explicit-phases`](explicit-phases.md) rule.
