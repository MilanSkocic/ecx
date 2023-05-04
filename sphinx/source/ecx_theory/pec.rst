PEC
====
The :mod:`skelectrox.pec.core` module aims at simplifying the generation and fitting of data from photoelectrochemical
measurements.

Introduction
------------

Photo-electrochemistry characterizations are used to study films at macroscopic, mesoscopic, and microscopic scales.
The latter advances were used to support (photo-)electrochemical studies of the electronic and optical properties of
passive films and oxidized metals, and of their interfaces with electrolytes, providing informations on the nature
and structure of these materials and to use properties such as the oxidation behaviour of a metallic substrate.

Basically, two kinds of curves are recorded in the course of photoelectrochemical characterization experiments,
photocurrent voltammograms and photocurrent energy spectra. In photocurrent voltammograms, photocurrents are measured
as a function of the potential, :math:`V`, applied to the semiconducting electrode, at a given photon energy,
:math:`E=h\nu`. In photocurrent energy spectra, photocurrents are recorded, at a given applied potential, V,
as a function of the photon energy, :math:`E`. The analysis of the shapes of photocurrent voltammograms may
allow to obtain informations such as the semiconducting type of the material, the energy of the surface band levels,
the presence of macroscopic defects inducing photogenerated electron--hole pairs recombinations.

However, despite attempts to refine the Gartner-Butler model by taking into account surface or volume recombination,
a complete description of the photocurrent voltammograms remains difficult, for the latter developments make use of
a high number of adjustable parameters, most of them being very difficult to assess. The analysis of the photocurrent
energy spectra is intended to identify the chemical nature of the material constituting the semiconducting electrode,
through the value of their bandgap energies, :math:`E_g` as, on the one hand, bandgap energy values have been reported
in the literature for numerous compounds, and as, on the other hand, bandgap values may be estimated from thermodynamic
extensive atomic data. Practically, photocurrent energy spectra are usually analyzed by means of linear transforms to
take benefit of the fact that, using the simplified form of the Gartner--Butler model, the quantum yield, :math:`\eta`,
of the photocurrent is proportional to the light absorption coefficient as shown in :eq:`eq_quantum_yield`.

In such conditions, :math:`\eta`, obeys to the following relationship:

.. math::
    :label: eq_quantum_yield
    
			(\eta * E)^{1/n} = K(E-E_g)

where :math:`K` is a constant (things other than :math:`E` being equal), :math:`E_g` is the bandgap energy of the semiconductor, and :math:`n` depends on the band to band transition type, :math:`n=1/2` for an allowed direct transition, and :math:`n=2` for an allowed indirect transition. Direct transitions are rarely observed in more or less disordered thin oxide films. 

Fitting of the Photocurrent Energy Spectra
------------------------------------------

Linear transformations were successfully performed for oxides made of one or two constituents. 
However, for complex oxide scales formed of several p-type and n-type phases, 
the complete description of the photocurrent energy spectra could not be achieved, 
and only semi-quantitative and/or partial informations could be obtained on the oxides present in the scales. 

As :math:`I_{PH}^{\ast}` is measured under modulated light conditions and thus actually is a complex number, 
the real and the imaginary parts of the photocurrent  should be considered simultaneously 
when analyzing and fitting the photocurrent energy spectra, rather than their modulus as shown in :eq:`eq_iph`.

.. math::
    :label: eq_iph

            I_{PH}^{\ast}& = \vert I_{PH}^{\ast} \vert \cos \theta
            + j \vert I_{PH}^{\ast} \vert \sin \theta \\
            I_{PH}^{\ast}& = \sum _{i}^{i=N} J_{PH,i} \cos \theta _{i} + j \sum _{i}^{i=N} J_{PH,i} \sin \theta _{i}
			
where :math:`J_{PH,i}` and :math:`\theta _{i}` represent the modulus and phase shift, 
respectively, of the photocurrent issued from the ith semiconducting constituent of the oxide layer. 
For thin semiconducting films, the space charge regions are low compared to penetration depth of the light. 
:math:`J_{PH,i}` may thus be expected, at a given applied potential, to follow the simplified form of the 
Gartner--Butler model.

.. math::
    :label: eq_jph
			(J_{PH,i} * E)^{1/n} = K_{i}(E-E_{g,i})

where :math:`E_{g,i}` and :math:`K_{i}` represent the energy gap and a value 
proportional to :math:`K` (:math:`I_{PH}^{\ast}` * is proportional to but not equal to :math:`\eta`) for 
the ith semiconducting constituent.

An example of the modulus and the phase computed with 4 semiconducting phases:

===== ========= 
Names Values    
===== ========= 
K1    +4.00e-05 
O1    -5.00e+01 
Eg1   +1.70e+00 
n1    +2.00e+00 
K2    +6.00e-05 
O2    +1.30e+02 
Eg2   +2.40e+00 
n2    +2.00e+00 
K3    +5.00e-05 
O3    +1.40e+02 
Eg3   +2.80e+00 
n3    +2.00e+00 
K4    +9.00e-05 
O4    -5.00e+01 
Eg4   +3.50e+00 
n4    +2.00e+00 
===== ========= 

.. _fig_pec_modulus:
.. figure:: ../examples/figures/PEC-4SC_Mod.png
    :width: 600
    :alt: PEC Modulus

    PEC Modulus

.. _fig_pec_phase:
.. figure:: ../examples/figures/PEC-4SC_Phase.png
    :width: 600
    :alt: PEC Phase

    PEC Phase


References
-------------
:cite:t:`Petit2013,Morrison1980,Memming2008,Stimming1986,Butler1978,Butler1977`
    
