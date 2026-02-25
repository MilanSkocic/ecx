"""Python wrapper of the (Modern Fortran) ecx library."""
from typing import Union
import numpy as np
import array
from . import _ecx

__version__ = _ecx.__version__


# utilities
def _cast_ndarray(X):
    """
    Cast X to numpy 1d-array.

    Parameters
    ----------
    X: int, floar, array-like
        Variable to be casted.
    Returns
    -------
    X_: 1d-array
        Numpy ndarray of rank 1.
    """
    scalar = False
    if isinstance(X, (int, float)):
        X_ = np.asarray((X,), dtype="f8")
        scalar = True
    elif isinstance(X, np.ndarray):
        if X.ndim == 1:
            X_ = np.asarray(X, dtype="f8")
        else:
            raise TypeError("X must be a 1d-array of floats.")
    elif isinstance(X, array.array):
        X_ = np.asarray(X, dtype="f8")
    else:
        raise TypeError("X must be a 1d-array of floats.")

    return X_, scalar



def z(e:str, w:Union[np.ndarray,array.array,int,float], p:Union[np.ndarray,array.array])->np.ndarray:   
    """
    Compute the complex impedance of the element e.
    """
    _e = str(e)
    _w, w_scalar = _cast_ndarray(w)
    _p, p_scalar = _cast_ndarray(p)

    if p_scalar:
        raise TypeError("p must an array-like object with 3 elements.")
    
    res = _eis.z(_e, _w, _p)

    if w_scalar:
        return res[0]
    else:
        return res


