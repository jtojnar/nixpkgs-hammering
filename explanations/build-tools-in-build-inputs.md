The following packages are primarily build tools so they likely go to `nativeBuildInputs`, not `buildInputs`:

* `cmake`
* `meson`
* `ninja`
* `pkg-config`

The distinction primarily matters when [cross-compiling](https://nixos.org/nixpkgs/manual/#chap-cross) a package for a different architecture than the one the build runs on – if you want to run a program during a package’s build, its *host* (runtime) architecture needs to match the package’s *build* architecture, or the operating system might not be able to execute it.

Dependencies listed in `nativeBuildInputs` will ensure precisely that, while those in `buildInputs` will have the same *host* platform as the built package.

Note: In most derivations, when not cross-compiling, the programs listed in `buildInputs` will end up in [`PATH`](https://github.com/NixOS/nixpkgs/blob/390d38400aa7a425abef6e20c6773e2717b2fda1/pkgs/stdenv/generic/setup.sh#L486-L488) environment variable for build too. But you can force the distinction by setting `strictDeps = true;`; and [`python3.pkgs.buildPythonPackage`](https://github.com/NixOS/nixpkgs/blob/01b0290516db18ebfda5eee3b830fe5c0cebcf4b/pkgs/development/interpreters/python/mk-python-derivation.nix#L50-L51) and `rustPlatform.buildRustPackage` already enable that option by default.

## Exceptions
* When building an environment for an IDE, you will likely want to be able to run the build tools at runtime so they should go to `buildInputs` (possibly to both).
