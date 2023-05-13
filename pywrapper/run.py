import numpy as np
from pyecx import eis
import matplotlib.pyplot as plt

R = 100
C = 1e-6
Q = 1e-6
a = 0.85
L = 1e-2
s = 5.0
w = np.logspace(6, -3, 100)

zr = np.asarray(eis.zr(w, R))
zc = np.asarray(eis.zc(w, C))
zl = np.asarray(eis.zl(w, L))
zcpe = np.asarray(eis.zcpe(w, Q, a))
zw = np.asarray(eis.zw(w, s))
zrc = zr*zc / (zr+zc)
zrl = zr*zl / (zr+zl)
zrq = zr*zcpe / (zr+zcpe)
print("finish")

fig = plt.figure()
ax = fig.add_subplot(111)

ax.set_aspect("equal")
ax.plot(zrc.real, zrc.imag, "g.", label="R/C")
ax.plot(zrl.real, zrl.imag, "r.", label="R/L")
ax.plot(zrq.real, zrq.imag, "b.", label="R/Q")
ax.plot(zw.real, zw.imag, "m.", label="W")

ax.invert_yaxis()

plt.show()


