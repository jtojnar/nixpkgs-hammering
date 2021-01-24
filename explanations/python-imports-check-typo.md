When a Python package not provide tests, or making them pass in Nixpkgs is too difficult, expression should contain at least [`pythonImportsCheck`](https://nixos.org/manual/nixpkgs/unstable/#using-pythonimportscheck) to check that each of the modules declared by the package can be `import`ed. This effectively tests for many packaging errors.

`pythonImportsCheck` can be used like this:

```nix
buildPythonPackage {
  pname = "mymodule";
  version = "1.0.0";

  src = …;

  pythonImportsCheck = [
    "mymodule"
  ];
}
```

Note: it is easy to make a typo in the key `pythonImportsCheck` here, so watch out for that.
