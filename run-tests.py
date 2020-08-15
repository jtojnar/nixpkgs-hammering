#!/usr/bin/env python3

import os
import subprocess

script_dir = os.path.dirname(os.path.realpath(__file__))


def test_variant(rule, variant=None):
    attr_path=f'{rule}.{variant}' if variant is not None else rule
    test_build = subprocess.run(
        [
            os.path.join(script_dir, 'tools/nixpkgs-hammer'),
            '-f', './tests',
            attr_path
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )

    if test_build.returncode != 0:
        print('\t\terror building the test')
    elif f'explanations/{rule}.md'.encode('utf-8') not in test_build.stdout:
        print('\t\terror matching the rule')
    else:
        print('\t\tok')


def test_rule(rule, variants=None):
    print(f'Testing {rule}')

    if variants is not None:
        for variant in variants:
            print(f'\t{variant}')
            test_variant(rule, variant)
    else:
       test_variant(rule)


if __name__ == '__main__':
    test_rule(
        'build-tools-in-build-inputs',
        [
            'cmake',
            'meson',
            'ninja',
            'pkg-config',
        ],
    )

    test_rule(
        'meson-cmake'
    )

    test_rule(
        'patch-phase'
    )
