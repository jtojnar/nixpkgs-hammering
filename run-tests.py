#!/usr/bin/env python3

import os
import subprocess
import textwrap
import unittest

script_dir = os.path.dirname(os.path.realpath(__file__))

def make_test_variant(rule, variant=None, should_match=True):
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
        else:
            matches = f'explanations/{rule}.md'.encode('utf-8') in test_build.stdout
            if should_match and not matches:
                raise Exception('error matching the rule')
            elif not should_match and matches:
                raise Exception('rule should not match')

    return case


def make_test_rule(rule, matching_variants=None, nonmatching_variants=[]):
    if matching_variants is not None:
        suite = unittest.TestSuite()
        for variant in matching_variants:
            suite.addTest(FunctionTestCase(make_test_variant(rule, variant), description=f'{rule}.{variant}'))

        for variant in nonmatching_variants:
            suite.addTest(FunctionTestCase(make_test_variant(rule, variant, should_match=False), description=f'{rule}.{variant}'))

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
            'attribute-ordering',
            [
                'out-of-order',
            ],
            [
                'properly-ordered',
            ]
        )

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
            'duplicate-check-inputs',
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
            'python-explicit-check-phase',
            [
                'redundant-pytest',
            ],
            [
                'nonredundant-pytest',
            ]
        )

        yield make_test_rule(
            'python-imports-check-typo',
            [
                'pythonImportTests',
                'pythonImportCheck',
                'pythonImportsTest',
                'pythonCheckImports',
            ],
            [
                'pythonImportsCheck',
            ]
        )

        yield make_test_rule(
            'python-include-tests',
            [
                'no-tests-no-import-checks',
                'tests-disabled-no-import-checks',
            ],
            [
                'pytest-check-hook',
                'explicit-check-phase',
                'has-imports-check'
            ]
        )

        yield make_test_rule(
            'python-inconsistent-interpreters',
            [
                'mixed-1',
                'mixed-2',
            ],
            [
                'normal',
            ]
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
                'lgpl3-python',
            ],
            [
                'single-nonmatching-license',
            ]
        )

def load_tests(loader, tests, pattern):
    return TestSuite()

if __name__ == '__main__':
    unittest.main(verbosity=2)
