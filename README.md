# nixpkgs-hammering

There are many idioms in nixpkgs which beginner packagers might not be aware of. This is a set of nit-picky rules that aim to point out and explain common mistakes in nixpkgs package pull requests.

This repository contains a bunch of [overlays](https://nixos.org/nixpkgs/manual/#chap-overlays) that add extra checks to `stdenv.mkDerivation` and other similar nixpkgs tools. The `nixpkgs-hammer` command will try to evaluate the specified attributes with the overlays, making sure the warnings only touch the attributes you care about, not their dependencies.

*Note that while these rules almost always apply, there are some exceptions. Please read the explanations before taking an action.*

## How do I use this?

Run the following command in your nixpkgs directory when you use stable Nix:

```
nix run -f https://github.com/jtojnar/nixpkgs-hammering/archive/master.tar.gz -c nixpkgs-hammer <attr-path>...
```

or with Flakes-enabled Nix:

```
nix run github:jtojnar/nixpkgs-hammering <attr-path>...
```

or when you use unstable Nix but do not have Flakes enabled:

```
nix shell -f https://github.com/jtojnar/nixpkgs-hammering/archive/master.tar.gz -c nixpkgs-hammer <attr-path>...
```

## How does this work?

There are two kinds of checks.

The first kind can be expressed directly in Nix and they are implemented as Nixpkgs overlays that replace `stdenv.mkDerivation` and other similar functions and attach an attribute containing a report to the resulting derivation’s attribute set. The tool then evaluates the attribute.

The second require extra facilities so the tool will execute them individually, passing them the attribute paths to check, the corresponding file paths, and (if available) build logs. They can be arbitrary programs so they can do as they please – for example, parse the code into [AST](https://en.wikipedia.org/wiki/Abstract_syntax_tree), read build logs, inspect the build output or even access network.

## How do I develop this?

Run tests:

```
nix shell -c ./run-tests.py
```

> **Note**
> The overlays of new checks must be added to the Git index in order for nixpkgs-hammering to discover them.

## License

The code is licensed under [MIT](LICENSE.md), the explanations are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
