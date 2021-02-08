Passing `buildFlagsArray` or other similar attributes as an argument to `stdenv.mkDerivation` does not do what you would expect it to.

If you pass an attribute containing a list of strings to `mkDerivation`, Nix will intercalate the elements with spaces and pass the whole list to the builder as a single string. The builder will then only be able to extract a single item from `"${buildFlagsArray[@]}"`, containing all elements of the list concatenated together.

Bash also does not really interpret the values of variables passed to derivations so it does not matter if you include quotes, apostrophes, backslashes, dollar signs or any other special characters – they will be passed to the Bash `buildFlagsArray` variable literally.

It does sort of work as expected if you only pass it a single flag (or multiple list items that will be concatenated together contrary to the misleading quoting) but you should not rely on that since another person might want to add more flags and then will end up confused why it does not work.

I recommend using `buildFlags` in Nix if you are certain your list items do not contain spaces. If any of them may contain spaces, you will have to resort to setting `buildFlagsArray` in Bash (e.g. in `preBuild`). Unfortunately, we cannot really do any better until we switch to [`__structuredAttrs`](https://github.com/NixOS/nixpkgs/pull/72074).

## Example
### Before
```nix
stdenv.mkDerivation {
  …

  makeFlagsArray = [
    "PREFIX=${placeholder "out"}"
    "LIBDIR=${placeholder "out"}/lib"
  ];
}
```

This will result in a the contents of the array being passed to make as a single argument: `make "PREFIX=$out LIBDIR=$out/lib"`.

### After
```nix
stdenv.mkDerivation {
  …

  preBuild = ''
    makeFlagsArray+=(
      "PREFIX=${placeholder "out"}"
      "LIBDIR=${placeholder "out"}/lib"
    )
  '';
}
```
