Passing both `name` and `version` arguments is probably a mistake.

`stdenv.mkDerivation` can create the derivation `name` automatically by joining its `pname` and `version` arguments as `${pname}-${version}`. This does not happen if you pass `name` argument explicitly – in that case, you will be responsible for appending version string to the derivation name.

In most cases you can just pass separate *project name* (`pname`) and `version` arguments and forget about the derivation name.

`mkDerivation` only started supporting that relatively recently so you may find older expressions that explicitly construct `name`.

## Possible exceptions

When you want to distinguish multiple variants of a project in the *derivation name* but want to keep the `pname` argument the same.
