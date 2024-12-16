r"""Tests"""
import pyecx


def test_version():
    expected = None
    with open("VERSION", "r") as f:
        expected = f.read().strip()
    value = pyecx.version.__version__
    assert value == expected
