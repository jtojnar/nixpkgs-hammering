#!/usr/bin/env python3

import os
import subprocess
import textwrap
import unittest

script_dir = os.path.dirname(os.path.realpath(__file__))

def make_test_variant(rule, variant=None):
    def case():
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
            raise Exception('error building the test:' + test_build.stdout.decode('utf-8'))
        elif f'explanations/{rule}.md'.encode('utf-8') not in test_build.stdout:
            raise Exception('error matching the rule')

    return case


def make_test_rule(rule, variants=None):
    if variants is not None:
        suite = unittest.TestSuite()
        for variant in variants:
            suite.addTest(FunctionTestCase(make_test_variant(rule, variant), description=f'{rule}.{variant}'))
        return suite
    else:
       return FunctionTestCase(make_test_variant(rule), description=rule)


class FunctionTestCase(unittest.FunctionTestCase):
    # We do not care that the test class is unittest.case.FunctionTestCase (case)
    def __str__(self):
        return self._description
    # Do not print description twice
    def shortDescription(self):
        return None


class TestSuite(unittest.TestSuite):
    # do not run _removeTestAtIndex since there is nothing in _tests
    _cleanup = False

    def __iter__(self):
        yield make_test_rule(
            'build-tools-in-build-inputs',
            [
                'cmake',
                'meson',
                'ninja',
                'pkg-config',
            ],
        )

        yield make_test_rule(
            'explicit-phases',
            [
                'configure',
                'build',
                'check',
                'install',
            ],
        )

        yield make_test_rule(
            'fixup-phase'
        )

        yield make_test_rule(
            'meson-cmake'
        )

        yield make_test_rule(
            'missing-phase-hooks',
            [
                'configure-pre',
                'configure-post',
                'configure-both',
                'build-pre',
                'build-post',
                'build-both',
                'check-pre',
                'check-post',
                'check-both',
                'install-pre',
                'install-post',
                'install-both',
            ],
        )

        yield make_test_rule(
            'patch-phase'
        )

        yield make_test_rule(
            'unnecessary-parallel-building',
            [
                'cmake',
                'meson',
                'qmake',
                'qt-derivation',
            ],
        )

        yield make_test_rule(
            'unclear-gpl',
            [
                'agpl3',
                'fdl11',
                'fdl12',
                'fdl13',
                'gpl1',
                'gpl2',
                'gpl3',
                'lgpl2',
                'lgpl21',
                'lgpl3',
            ],
        )

def load_tests(loader, tests, pattern):
    return TestSuite()

if __name__ == '__main__':
    unittest.main(verbosity=2)
