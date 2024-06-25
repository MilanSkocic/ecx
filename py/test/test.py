r"""Tests"""
import unittest
import pyecx
import numpy as np


class TestVersion(unittest.TestCase):
    r"""Test version module."""

    def test_version(self):
        expected = None
        with open("VERSION", "r") as f:
            expected = f.read().strip()
        value = "0.1.0"
        self.assertEqual(value, expected)
