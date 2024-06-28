r"""Tests"""
import unittest
import pyecx


class TestVersion(unittest.TestCase):
    r"""Test version module."""

    def test_version(self):
        expected = None
        with open("VERSION", "r") as f:
            expected = f.read().strip()
        value = pyecx.version.__version__
        self.assertEqual(value, expected)
