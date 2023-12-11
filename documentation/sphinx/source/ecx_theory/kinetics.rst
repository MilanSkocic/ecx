Kinetics
===========
Kinetics electrochemistry aims at computing the current that will flow between oxidants and reductants 
in a solvent, i.e. water or organic solvents with respect to the electrochemical potential.
The electrochemical potential provides the position in the thermodynamic scale of the Ox/Red couple 
through the Nernst equation. 
At equilibrium, the electrochemical potential can be referred as the 
:math:`OCV` (Open Circuit Voltage) or :math:`U_{I=0}`.
The relationship between the potential and the current is given by the butler-Volmer equation :cite:p:`bard2002`.

Nernst potential
------------------
The electrochemical potential is defined by :eq:`eq_nernst_pot`. 

.. math::
    :label: eq_nernst_pot 

    U = U^0 + \frac{RT}{zF} \ln \frac{\prod a_{ox,i}^{\nu _{ox,i}}}{\prod a_{red,i}^{\nu _{red,i}}}

where:

* :math:`U` is the electrochemical potential of the couple Ox/Red.
* :math:`U^0` is the standard electrochemical potential of the couple Ox/Red.
* :math:`z` is the number of exchanged electrons.
* :math:`a_i` are the activities.
* :math:`\nu _i` are the stoechiometric coefficients of the activities.
* :math:`R` is the ideal gas constant.
* :math:`F` is the Faraday constant.

In the case of corrosion of metals, the latter are the reductants (e.g. Fe, Cr, Ni...)
and the oxidants are in the solvent. 

An example with both oxidant and reductant present in water:

.. math::

    Fe^{3+} + e^- \leftrightarrow Fe^{2+}

    U_{Fe^{3+}/Fe^{2+}} =  U_{Fe^{3+}/Fe^{2+}}^0 + \frac{RT}{F} \ln \frac{a_{Fe^{3+}}}{a_{Fe^{2+}}}
    
    U_{Fe^{3+}/Fe^{2+}} =  U_{Fe^{3+}/Fe^{2+}}^0 + \frac{RT}{F} \ln \frac{\gamma _{Fe^{3+}}[Fe^{3+}]}{\gamma _{Fe^{2+}}[Fe^{2+}]}


Buttler-Volmer
-----------------

The Butler-Volmer equation provides the current density with respect to the electrochemical potential :math:`U_{I=0}`
or :math:`OCV`. when there is no limitation by mass transfer is given in :eq:`eq_sbv` and in
:eq:`eq_bv` when there is limitation by mass transfer. The Butler-Volmer equation shows that the total current density
is the sum of the anodic and the cathodic contributions.

.. math::
    :label: eq_sbv

    j = j^0 \left( \exp \frac{\alpha _{a}z_{a} \eta}{RT/F} - \exp \frac{-\alpha _{c}z_{c} \eta}{RT/F} \right)

    j = j_a + j_c

.. math::
    :label: eq_bv    

    j = \frac{j^0 \left( \exp \frac{\alpha _{a}z_{a} \eta}{RT/F} - \exp \frac{-\alpha _{c}z_{c} \eta}{RT/F} \right)}
        {1+\frac{j^0}{j_{dl,a}} \exp \frac{\alpha _{a}z_{a} \eta}{RT/F} + \frac{j^0}{j_{dl,c}} \exp \frac{-\alpha _{c}z_{c} \eta}{RT/F}}

    j = \frac{j_a + j_c}{1 + \frac{j_a}{j_{dl,a}} + \frac{j_c}{j_{dl,c}}}

where:

* :math:`\eta` is the overpotential defined as :math:`U-U_{I=0}`.
* :math:`U_{I=0}` is the electrochemical potential at equilibrium.
* :math:`j^0` is the exchange current density.
* :math:`j_{dl}` is the limiting diffusion current density.
* :math:`j` is the total current density.
* :math:`z` is the number of exchange electrons.
* :math:`\alpha` is the transfer coefficient.
* :math:`R` is the ideal gas constant.
* :math:`F` is the Faraday constant.

The total current is obtained by scaling the current density by the area as shown in :eq:`eq_j_to_I`.

.. math::
   :label: eq_j_to_I

    I = j \cdot A

Small overpotential
^^^^^^^^^^^^^^^^^^^^^
Let's consider that :math:`\eta << 1`, the equation :eq:`eq_sbv` can be 
simplified with the first order Taylor series as shown in :eq:`eq_sbv_small_eta`.

.. math::
    :label: eq_sbv_small_eta

    j = j^0 \left( 1 + \frac{\alpha _{a}z_{a} \eta}{RT/F} - 1 + \frac{\alpha _{c} z_{c} \eta}{RT/F} \right)

When :math:`\alpha _{a}+\alpha _{c}=1` and :math:`z _{a}=z _{c} = z`, the current can be expressed with respect
to :math:`\eta` and :math:`R_{ct}` as defined in :eq:`eq_sbv_small_eta_Rct`.

.. math::
    :label: eq_sbv_small_eta_Rct

    j = j^0 \frac{zF}{RT} \eta
    
    I = \frac{\eta}{\frac{RT}{Fj^0A}} = \frac{\eta}{R_{ct}}

where:

* :math:`R_{ct}=\frac{RT}{Fj^0A}` is the charge transfer resistance.


Large overpotentials
^^^^^^^^^^^^^^^^^^^^^^^

Large overpotentials, either :math:`\eta \rightarrow \infty` or :math:`\eta \rightarrow -\infty`,
the expression of the Butler-Volmer equation simplifies in the anodic and cathodic domain as shown in
:eq:`eq_bv_large_eta`. The latter are used for determining the coefficient transfers :math:`\alpha _{a}, \alpha _{c}`
in the Tafel representation of the :math:`I=f(U)` curve i.e. :math:`\log _{10}\vert j \vert = f(U)`

When :math:`\eta \rightarrow \infty`:

.. math::
    :label: eq_bv_large_eta

    j = j_a = j^0 \exp \alpha _{a} z_{a} \frac{\eta}{RT/F}

    \ln \vert j \vert  = \ln j^0  + \alpha _{a} z_{a} \frac{\eta}{RT/F} = \ln j^0 + \frac{\eta}{\frac{RT}{F\alpha _{a}z_{a}}} = \ln j^0 + \frac{\eta}{b_{a}}

    log_{10} \vert j \vert = log_{10} j^0 + \frac{\eta}{b_{a}\ln 10} = \ln j^0 + \frac{\eta}{\beta _{a}}

Symmetrically, when :math:`\eta /rightarrow -\infty`
    
.. math::

    j = j_c = -j^0 \exp -\alpha _{c} z_{c} \frac{\eta}{RT/F}
    
    \ln \vert j \vert  = \ln j^0  - \alpha _{c} z_{c} \frac{\eta}{RT/F} = \ln j^0 - \frac{\eta}{\frac{RT}{F\alpha _{c}z_{c}}} = \ln j^0 - \frac{\eta}{b_{c}}

    log_{10} \vert j \vert = log_{10} j^0 - \frac{\eta}{b_{c}\ln 10} = \ln j^0 - \frac{\eta}{\beta _{c}}

where:

* :math:`\beta = \frac{RT}{F\alpha z}` is the slope in the Tafel plot.



