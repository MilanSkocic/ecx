import numpy as np
import pyecx

R = 100
w = np.logspace(6, -3, 10)
print("hhh", w.itemsize)
z = pyecx.zr(1, R)
print(z)

z = pyecx.zr(w, R)
print(z, z.strides, z.dtype)