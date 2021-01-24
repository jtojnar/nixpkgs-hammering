In Python package expressions, `propagatedBuildInputs` is used to list dependencies that are required to be available at runtime. `checkInputs` lists dependencies that are required specifically during the `checkPhase`.

All dependencies from `propagatedBuildInputs` are available during `checkPhase`, so there is no need to duplicate them in the `checkInputs`.
