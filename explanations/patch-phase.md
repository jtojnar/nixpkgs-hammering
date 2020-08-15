You should not override `patchPhase`.

`patchPhase` is responsible for [applying `patches`](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/stdenv/generic/setup.sh#L918-L944) so if you override it without carefully replicating the original behaviour, you will likely confuse someone trying to add a patch to `patches` in the future.

Add your commands to `postPatch` hook instead.

Avoid using `prePatch` too. It might change the source code so that the patches in `patches` no longer apply and when that happens, it is often easier to handle the conflict by tweaking a command in `postPatch` than modifying a patch.

If you need to pass some arguments to `patch` call, for example, to handle non-standard paths using `-p0`, using [`fetchpatch`](https://github.com/NixOS/nixpkgs/blob/d71a03ad695407dd482ead32d3eddff50092a1c3/pkgs/build-support/fetchpatch/default.nix#L12) to modify the patch might be nicer.
