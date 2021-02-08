`buildFlags` and other similar attributes are passed around unquoted in stdenv. This means Bash will split them along [`$IFS`](https://tldp.org/LDP/abs/html/internalvariables.html#IFSREF) when given as arguments to a program or when iterated over in a loop. The downside is that you cannot pass flags containing spaces to stdenv using these variables.

Bash also does not really interpret the values of variables passed to derivations so it does not matter if you include quotes, apostrophes, backslashes, dollar signs or any other special characters – you will not be able to sidestep this splitting behaviour.

To fix this, add the flags to `buildFlagsArray` in one of the Bash hooks (e.g. in `preBuild`). Unfortunately, `*FlagsArray` [cannot be used](../no-flags-array.md) as a `mkDerivation` argument in Nix.

## Examples
### Before
```nix
stdenv.mkDerivation {
  …

  makeFlags = [
    "RELEASE=August 2020"
  ];
}
```

### After
```nix
stdenv.mkDerivation {
  …

  preBuild = ''
    makeFlagsArray+=(
      "RELEASE=August 2020"
    )
  '';
}
```

## Exceptions
If the list item in question are actually multiple arguments:

```nix
stdenv.mkDerivation {
  …

  configureFlags = [
    "--with-foo bar"
  ];
}
```

you should make the division explicit:

```nix
  configureFlags = [
    "--with-foo" "bar"
  ];
```

or, if they are a key and a value and the script supports it, join them using `=`:

```nix
  configureFlags = [
    "--with-foo=bar"
  ];
```

