Nixpkgs contains a [`pytestCheckHook`](https://nixos.org/manual/nixpkgs/unstable/#using-pytestcheckhook) that can automatically run tests using pytest.

For example, rather than

```nix
buildPythonPackage {
  checkInputs = [
    pytest
    …
  ];

  checkPhase = ''
    pytest
  '';
}
```

consider using

```nix
buildPythonPackage {
  checkInputs = [
    pytestCheckHook
    …
  ];
}
```

Also note that many flags that you might want to pass to `pytest` can be passed automatically through `pytestCheckHook`.

`buildPythonPackage` accepts:

- `disabledTests` to disable particular pytest tests.
- `disabledTestPaths` to disable particular pytest files or entire directories.
- `pytestFlagsArray` to pass flags to pytest. This should not be used to disable tests or test files.


Here is a complete example using `pytestCheckHook`, `pytestFlagsArray`, and `disabledTests` and `disabledTestPaths`:

```nix
buildPythonPackage {
  …

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--timeout=30"
  ];

  disabledTests = [
    "test_function_1"
  ];

  disabledTestPaths = [
    "tests/some_file.py"
    "tests/reproducible"
  ];
}
```
