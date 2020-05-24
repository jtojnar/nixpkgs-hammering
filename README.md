# nixpkgs-hammering

There are many idioms in nixpkgs which beginner packagers might not be aware of. This is a set of nit-picky rules that aim to point out and explain common mistakes in nixpkgs package pull requests.

This repository contains a bunch of [overlays](https://nixos.org/nixpkgs/manual/#chap-overlays) that add extra checks to `stdenv.mkDerivation` and other similar nixpkgs tools. The `nixpkgs-hammer` command will try to build the specified attributes with the overlays, making sure the warnings only touch the attributes you care about, not their dependencies.

*Note that while these rules almost always apply, there are some exceptions. Please read the explanations before taking an action.*

## How do I use this?

Run the following command in your nixpkgs directory:

```
nix run -f https://github.com/jtojnar/nixpkgs-hammering/archive/master.tar.gz -c nixpkgs-hammer <attr-path>...
```

## How does this work?

In order to make the checks not apply to unwanted derivations, we need to pass the information about our targets to the overlays. Unfortunately, we cannot use the attribute paths, since the `mkDerivation` function is not aware of them. Nix does offer minor meta-programming facility through `builtins.unsafeGetAttrPos` but we cannot use the positions of the attributes for the same reason. We could try matching the `name` attributes but there might be multiple packages with the same `name` depending on each other. But we can combine the two approaches and get the position of `name` attribute within the expression – this should uniquely identify the expression and be available among the `mkDerivation` arguments.

## Why overlays?

We could try to analyse the syntax of an expression but outside of context of nixpkgs we would have no semantics (perhaps we do not care and syntax only rules would be sufficient). Also I was too lazy to parse the syntax with hnix.

## License

The code is licensed under [MIT](LICENSE.md), the explanations are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
