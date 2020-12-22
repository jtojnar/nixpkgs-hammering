Meson supports CMake as an alternative method for finding dependencies and will print the following message when checking dependencies:

```
Did not find CMake 'cmake'
Found CMake: NO?
```

That is just an informational message you do not need to pay much heed. `pkg-config` is the preferred method for finding dependencies on UNIX systems and will be sufficient most of the time.

## Exceptions
You need both tools in the following cases:

* a project builds subprojects using a different build system and it is non-trivial to separate the subprojects into separate Nix packages
  * a CMake project builds a Meson subproject
  * a Meson project builds a CMake subproject using the [experimental support](https://mesonbuild.com/CMake-module.html#cmake-subprojects)
  * a project using another build system builds subprojects using CMake and Meson
* a Meson project depends on a package that can only be located through a [CMake `find_package` system](https://mesonbuild.com/Release-notes-for-0-49-0.html#cmake-find_package-dependency-backend) and the dependency does not want to add `pkg-config` support upstream

Please add a comment with explanation if one of these applies.

## What to do?
Try removing `cmake` from dependencies and see if the package still builds.
