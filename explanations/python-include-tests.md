Some level of testing should be done for each Python package expression.

If the `checkPhase` reports there are no tests, it might be necessary to:

- If the tests are in a different directory than `tests/`, tell [`pytest`](https://nixos.org/manual/nixpkgs/unstable/#using-pytest) or [`pytestCheckHook`](https://nixos.org/manual/nixpkgs/unstable/#using-pytestcheckhook) where to find them.
- If the upstream source code repository contains tests but they are not shipped with package on PyPI, switch to fetching from the repository (e.g. using `fetchFromGitHub`) and open an issue upstream asking to ship tests in the PyPI packages ([example](https://github.com/gnome-keysign/babel-glade/issues/5)).
- If the package does not contain any tests, add `doCheck = false;` with a comment that there are no tests, and a [`pythonImportsCheck`](https://nixos.org/manual/nixpkgs/unstable/#using-pythonimportscheck) as a smoke test.
