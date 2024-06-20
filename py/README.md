# Introduction

Python wrapper around the
[Fortran ecx library](https://milanskocic.github.io/ecx/index.html).
The Fortran library does not need to be installed, the python wrapper embeds all needed dependencies for Windows and MacOS.
On linux, you might have to install `libgfortran` if it is not distributed with your linux distribution. 

All functions that operate on arrays, more precisely on objects with the buffer protocol, return memory views
in order to avoid compilation dependencies on 3rd party packages.


# Installation

In a terminal, enter:

```python
pip install pyecx
```


# Usage

```python
import numpy as np
from pyecx import eis
import matplotlib.pyplot as plt

R = 100
C = 1e-6
w = np.logspace(6, -3, 100)

zr = np.asarray(eis.zr(w, R))
zc = np.asarray(eis.zc(w, C))
zrc = zr*zc / (zr+zc)
print("finish")

fig = plt.figure()
ax = fig.add_subplot(111)

ax.set_aspect("equal")
ax.plot(zrc.real, zrc.imag, "g.", label="R/C")

ax.invert_yaxis()

plt.show()
```


# License

MIT
