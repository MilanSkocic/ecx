import numpy as np
import pyecx

R = 100
w = np.logspace(6, -3, 10)
z = pyecx.zr(1, R)
print(z)
