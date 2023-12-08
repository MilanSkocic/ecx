Kinetics
===========

Nernst potential
------------------

.. math::

   U = U^0 + \frac{RT}{zF} \ln \frac{\prod a_i^{ox}}{\prod a_i^{red}}


Buttler-Volmer
-----------------

No mass transfer limitation.

.. math::

   j = j^0 \left( \exp \frac{\alpha _{ox}z_{ox} (U-U_{I=0})}{RT/F} - \exp \frac{\alpha _{red}z_{red} (U-U_{I=0})}{RT/F} \right)

  
Mass transfer limitation

.. math::

   j = \frac{j^0 \left( \exp \frac{\alpha _{ox}z_{ox} (U-U_{I=0})}{RT/F} - \exp \frac{\alpha _{red}z_{red} (U-U_{I=0})}{RT/F} \right)}
        {1+\frac{j^0}{j_{dl,a}} \exp \frac{\alpha _{ox}z_{ox} (U-U_{I=0})}{RT/F} + \frac{j^0}{j_{dl,c}} \exp \frac{\alpha _{red}z_{red} (U-U_{I=0})}{RT/F}}

