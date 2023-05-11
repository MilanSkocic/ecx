import numpy as np
import pyecx
import matplotlib.pyplot as plt

R = 100
C = 1e-6
w = np.logspace(6, -3, 100)
print("hhh", w.itemsize)
z = pyecx.zr(1, R)
print(z)

zr = pyecx.zr(w, R)
zc = pyecx.zc(w, C)
zrc = zr*zc / (zr+zc)
print(zrc)

fig = plt.figure()
ax = fig.add_subplot(111)

ax.set_aspect("equal")

# ax.plot(zr.real, zr.imag, "k.", label="R")
# ax.plot(zc.real, zc.imag, "r.", label="C")
ax.plot(zrc.real, zrc.imag, "g.", label="R/C")

ax.invert_yaxis()

plt.show()


