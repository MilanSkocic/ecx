NAME
----

**kTe** - thermal voltage

LIBRARY
-------

Electrochemistry library - (**-libecx, -lecx)**

SYNOPSIS
--------

::

     pure elemental function kTe(T)result(r)

DESCRIPTION
-----------

Compute the thermal voltage: kTe[V] = kB[eV] \* (T[degC]+273.15)

Parameters:

**o T**
   Temperature in degC

RETURN VALUE
------------

**real(dp) :: r**
   Thermal voltage in Volts.

EXAMPLE
-------

Calling:

::

           value = kTe(T)

SEE ALSO
--------

**ecx(3)**
