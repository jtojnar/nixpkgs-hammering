If you just want to override some parameters of the build process, you might not need to override the phases. The default [generic builder](https://github.com/NixOS/nixpkgs/blob/b7ce309e6c6fbad584df85d9fd62c5185153e8f9/pkgs/stdenv/generic/setup.sh#L952-L1098) is quite flexible and allows you to control many aspects of the build using [variables](https://nixos.org/nixpkgs/manual/#ssec-controlling-phases).

## Why?
* It is an idiom in Nixpkgs.
* The default phases do lot of stuff behind the scenes and you would need to do that too, if you do not want for things to break.
* It saves you typing.

## Why not?
* It is an abstraction so general arguments against abstractions hold.

## When to use
Whenever the project you are packaging is using Autotools/make-based build tool. Or even other build tools – packages for Meson, CMake and many other build systems include setup hooks that extend the generic builders with their specific build steps.

## Examples
### Before
```nix
  configurePhase = ''
    NOCONFIGURE=1 ./autogen.sh
    ./configure --prefix=$out --with-udevdir=$out/lib/udev --sysconfdir=/etc
  '';

  buildPhase = ''
    make all docs INTROSPECTION_GIRDIR=$out/share/gir-1.0
  '';

  installPhase = ''
    make install install-docs sysconfdir=$out/etc INTROSPECTION_GIRDIR=$out/share/gir-1.0
  '';
```

### After
```nix
  configureFlags = [
    # --prefix is set by default: https://github.com/NixOS/nixpkgs/blob/b7ce309e6c6fbad584df85d9fd62c5185153e8f9/pkgs/stdenv/generic/setup.sh#L972
    "--with-udevdir=${placeholder "out"}/lib/udev"
    "--sysconfdir=/etc"
  ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder "out"}/share/gir-1.0"
  ];

  buildFlags = [ "all" "docs" ];

  installTargets = [ "install" "install-docs" ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';
```
