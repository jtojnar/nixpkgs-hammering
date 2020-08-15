You should not override `fixupPhase`.

`fixupPhase` is responsible for [various support functions](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/stdenv/generic/setup.sh#L1101-L1178) so if you override it without carefully replicating the original behaviour, you will likely break something.

Add your commands to `postFixup` or `preFixup` hook instead.

If you need to disable some action that happens during fixup, use relevant variable to disable it in a targetted way (e.g. [`dontStrip`](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/build-support/setup-hooks/strip.sh#L22-L24) for for `strip.sh`, [`dontPatchELF`](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/development/tools/misc/patchelf/setup-hook.sh#L5) for `patchelf`…).
