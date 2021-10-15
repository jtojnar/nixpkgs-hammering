#!/usr/bin/env nix-shell
#!nix-shell -i python
#!nix-shell -p nixUnstable
#!nix-shell -p "python3.pkgs.callPackage (fetchFromGitHub {owner = \"rmcgibbo\"; repo = \"adaptive-group-testing\"; rev = \"1b6b2522ec61f01ffd015f7a7731a2be92e12c2b\"; sha256 = \"13rwbjfrj28yx42kvyqikw761jg4x5gi2d4dn7zdvif8cyrbsf1r\"; }) { }"

from __future__ import annotations
import os
import subprocess
import json
import functools
from typing import List, Tuple
from adaptive_group_testing import generalized_binary_splitting
from tempfile import NamedTemporaryFile

KNOWN_ERROR_ATTRS = set(
    """acl
alertmanager-bot
apostrophe
attr
bash
binutils-unwrapped
bzip2
coreutils
coreutils-full
coreutils-prefixed
datadog-agent
diffutils
findutils
gawkInteractive
gcc-unwrapped
glibc
gnugrep
gnupatch
gnused
gnutar
gzip
holochain-go
javaPackages.junit_4_12
javaPackages.mavenHello_1_0
javaPackages.mavenHello_1_1
libgccjit
manim
mosdepth
ne
nim
nim-unwrapped
nimble-unwrapped
nimlsp
nimmm
nrpl
nuweb
texlive.combined.scheme-full
texlive.combined.scheme-medium
uberwriter
vimPlugins.fruzzy
zettlr
zfsbackup
""".splitlines()
)


@functools.lru_cache()
def test_chunk(chunk: Tuple[str, ...], nixpkgs_path: str) -> bool:
    cmd = (
        ["nixpkgs-hammer", "-f", nixpkgs_path] + list(chunk)
    )

    # print("  $ " + " ".join(cmd))
    p = subprocess.run(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if len(chunk) == 1 and p.returncode == 1:
        print(p.stdout.decode("utf-8"))
        print(p.stderr.decode("utf-8"))
    return p.returncode == 1


def nix_eval(attrs: Set[str], nixpkgs_path) -> Dict[str, Any]:
    # from https://github.com/Mic92/nixpkgs-review/blob/d89dcf354b8a25a69bbf0689b4b68f494de1ed48/nixpkgs_review/nix.py#L92
    with NamedTemporaryFile(mode="w+", suffix=".nix", delete=False) as nix_expr:
        print("""nixpkgs-path: attr-json:

    with builtins;
    let
    pkgs = import nixpkgs-path { config = { checkMeta = true; allowUnfree = true; }; };
    lib = pkgs.lib;

    attrs = fromJSON (readFile attr-json);
    getProperties = name: let
      attrPath = lib.splitString "." name;
      pkg = lib.attrByPath attrPath null pkgs;
      maybePath = builtins.tryEval "${pkg}";
    in rec {
      exists = lib.hasAttrByPath attrPath pkgs;
      broken = !exists || !maybePath.success;
    };
    in
    pkgs.lib.genAttrs attrs getProperties
        """, file=nix_expr)

    attr_json = NamedTemporaryFile(mode="w+", delete=False)
    delete = True
    try:
        json.dump(list(attrs), attr_json)
        attr_json.flush()
        cmd = [
            "nix",
            "--experimental-features",
            "nix-command",
            "eval",
            "--json",
            "--impure",
            "--expr",
            f"(import {nix_expr.name} {nixpkgs_path} {attr_json.name})",
        ]

        try:
            nix_eval = subprocess.run(
                cmd, check=True, stdout=subprocess.PIPE, text=True
            )
        except subprocess.CalledProcessError:
            delete = False
            print(
                f"{' '.join(cmd)} failed to run, {attr_json.name} was stored inspection"
            )
            raise

        return json.loads(nix_eval.stdout)
    finally:
        attr_json.close()
        nix_expr.close()
        if delete:
            os.unlink(attr_json.name)
            os.unlink(nix_expr.name)


def get_all_attrs(nixpkgs_path: str) -> Tuple[List[str], List[str]]:
    qaP_output = subprocess.check_output([
        "nix-env", "-qaP", "-f", nixpkgs_path, "--system-filter", "x86_64-linux"
    ], text=True)
    all_attrs = {e.split()[0] for e in qaP_output.splitlines()}
    attrs = {key for key, value in nix_eval(all_attrs, nixpkgs_path).items() if not value["broken"]}

    unknown_attrs = attrs - KNOWN_ERROR_ATTRS
    problematic_attrs = attrs & KNOWN_ERROR_ATTRS
    return unknown_attrs, problematic_attrs


def execute(args: argparse.Namespace):
    unknown_attrs, problematic_attrs = get_all_attrs(args.file)
    MAX_CONCURRENT_ATTRS = 2000

    def predicate(attrs):
        def chunker(seq, size):
            return (seq[pos : pos + size] for pos in range(0, len(seq), size))

        for chunk in chunker(attrs, MAX_CONCURRENT_ATTRS):
            if test_chunk(tuple(chunk), args.file):
                print(f"  Tested {len(chunk)}. Got a failure.")
                return True
        print(f"  Tested {len(attrs)}. No failures.")
        return False

    results1 = generalized_binary_splitting(predicate, unknown_attrs, d=2, verbose=True)
    results2 = generalized_binary_splitting(predicate, problematic_attrs, d=len(problematic_attrs), verbose=True)
    print(sorted(set(results1 + results2)))


def main():
    import argparse
    p = argparse.ArgumentParser()
    p.add_argument("-f", "--file",
        help="Path to nixpkgs checkout",
        default="<nixpkgs>"
    )
    args = p.parse_args()
    return execute(args)


if __name__ == "__main__":
    main()
