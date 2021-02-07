URI literal syntax has been deprecated by [RFC 45](https://github.com/NixOS/rfcs/pull/45) and should not be used any more. URIs should be quoted as regular strings.

## Examples
### Before
```nix
stdenv.mkDerivation {
  …

  meta.homepage = https://www.example.com;
}
```

### After
```nix
stdenv.mkDerivation {
  …

  meta.homepage = "https://www.example.com";
}
```
