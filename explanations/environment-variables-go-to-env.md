Environment variables should go inside `env` attribute instead of being passed directly to `stdenv.mkDerivation`.

Note that an environment variable can only contain a string. While attributes containing lists passed to `mkDerivation` would end up being concatenated, it should not be relied on as it can lead to confusion (e.g. [expecting certain tokenization](no-flags-spaces.md)). To avoid this, `mkDerivation` will only allow values that can be safely stringified in the `env` attribute (i.e. no lists).

## Example

### Before

```nix
stdenv.mkDerivation {
  …

  NIX_CFLAGS_COMPILE = "-lm -ld";
}
```

### After

```nix
stdenv.mkDerivation {
  …

  env = {
    NIX_CFLAGS_COMPILE = "-lm -ld";
  };
}
```

## Why this change?

By default, the attributes in the attribute set passed to [`derivation` function](https://nixos.org/manual/nix/stable/language/derivations.html) are turned into environment variables. That is still the primary method of passing data to the builder today but since environment variables can only contain strings, this limits the usable data types. Additionally, since environment variables tend to be inherited by child processes, the environment of various build tools would be contaminated by control variables of the builder.

To allow passing data other than strings to the builder [`__structuredAttrs`](https://nixos.mayflower.consulting/blog/2020/01/20/structured-attrs/) feature was introduced to Nix. It serializes the attributes passed to `derivation` into a JSON file and places it into the build directory. If a builder wants to allow customizing the environment in derivations with `__structuredAttrs`, it needs to designate a facility for that. The generic builder of Nixpkgs’s `stdenv.mkDerivation` allows that through the `env` attribute.
