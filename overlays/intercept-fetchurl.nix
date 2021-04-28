{ builtAttrs, packageSet, namePositions }@attrs:

final: prev:
let
  inherit (prev) lib;
  fd = builtins.getEnv "FETCHURL_TRACEFD";
  tracedFetchUrl = args: builtins.traceFd
    (lib.toInt fd)
    (builtins.toJSON args)
    (prev.fetchurl args);
  fetchurl =
    if fd == "" then
      prev.fetchurl
    else
      tracedFetchUrl;
in
  { fetchurl = fetchurl; }

