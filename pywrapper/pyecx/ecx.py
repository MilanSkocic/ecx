"""IAPWS computations."""
from typing import Union
import numpy as np
from numpy.typing import NDArray
from . import _ecx

def zr(w, r):
    
    v = _ecx.zr(w, r)
    if isinstance(v, memoryview):
        return np.asarray(v)
    else:
        return v

def zc(w, c):

    v = _ecx.zc(w, c)
    if isinstance(v, memoryview):
        return np.asarray(v)
    else:
        return v
