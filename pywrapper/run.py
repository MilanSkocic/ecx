import numpy as np
from pyecx import eis, core
import matplotlib.pyplot as plt

R = 100.0
C = 1e-6
Q = 1e-6
a = 0.85
L = 1e-2
s = 5.0
w = np.logspace(6, -3, 100)

print(core.PI)
print(np.asarray(core.nm2eV(np.asarray((1.0,)))))

p = np.asarray((R, 0.0, 0.0))
zr = np.asarray(eis.z("R", w, p))

p = np.asarray((C, 0.0, 0.0))
zc = np.asarray(eis.z("C", w, p))

p = np.asarray((L, 0.0, 0.0))
zl = np.asarray(eis.z("L", w, p))

p = np.asarray((Q, a, 0.0))
zcpe = np.asarray(eis.z("Q", w, p))

p = np.asarray((s, 0.0, 0.0))
zw = np.asarray(eis.z("W", w, p))

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


