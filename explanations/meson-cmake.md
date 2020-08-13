Meson supports CMake as an alternative method for finding dependencies and will print the following message when checking dependencies:

```
Did not find CMake 'cmake'
Found CMake: NO?
```

That is just an informational message you do not need to pay much heed. `pkg-config` is the preferred method for finding dependencies on UNIX systems and will be sufficient most of the time.

## What to do?

Try removing `cmake` from dependencies and see if the package still builds.
