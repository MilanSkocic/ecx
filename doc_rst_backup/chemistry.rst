Chemistry
=============

In chemistry, the most important parameter that is always needed for performing thermodynamic 
computations is the activity coefficient :math:`\gamma`. The latter is the correction applied to 
the concentration in order to compute the activity. The Debye-Huckel is extensively explained
in Bockris.


The Debye-Huckel (or ion-cloud) theory of ion-ion interaction
------------------------------------------------------------------

Activity coefficients and ion-ion interactions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Evolution of the concept of an acitivty coefficients

The existence of ions in solution, of interactions between these ions, and of a chemical-potential
change :math:`\Delta \mu _{i-I}` arising from ion-ion interactions have all been taken to be self-evident
in the treatment hitherto presented here. This, however, is a modern point of view. The thinking
about electrolytic solutions actually developped along different path.

Ionic solutions were at first treated in the same way as nonelectrolytic solutions, though the latter do not contain 
charged species. The starting point was the classical thermodynamic formula for the chemical potential :math:`\mu _i`
of a nonelectrolyte solute

.. math:: 
    :label: eq_chemical_potential

    \mu _i = \mu ^{0}_{i} + RT \ln x_i

In this expression, :math:`x_i` is the concentration of the solute in mole fraction units, and
:math:`\mu ^0 _i` is its the chemical potential in the standard state, i.e., when :math:`x_i` a standard
or a normalized value of unity

.. math::
    :label: eq_standard_chemical_potential

    \mu _i = \mu _i ^{0} \text{ when } x_i = 1

Since the solute particles in a solution of a nonlectrolyte are uncharged, they do not engage
in long-range Coulombic interactions. The short-range interaction arising from dipole-dipole or dispersion forces
become significant only when the mean distance between the solute particles is small, i.e., when the concentration
of the solute is high. Thus, one can to a good approximation say that there are no between solute particles
in dilute nonelectrolyte solutions. Hence, if :eq:`eq_chemical_potential` for the chemical potential of a solute
in a nonelectrolyte solution (with noninteracting particles) is used fot the chemical potential of an ionic species :math:`i`
in an electrolytic solution, then it is tantamount to ignoring the long-range Coulombic interactions between ions.
In an actual electrolytic solution, however, ion-ion interactions operate whether one ignores them or not.
It is obvious therefore that measurements of the chemical potential :math:`\mu _i` of an ionic species or, rather,
measurements of any property that depends on the chemical potential would reveal the error in :eq:`eq_chemical_potential`,
which is blind to ion-ion interactions. In other words, experiments show that even in dilute solutions,

.. math::
    :label: eq_chemical_potential_error

    \mu _i - \mu _i^0 \neq RT \ln x_i

In this context, a frankly empirical approach was adopted by earlier workers not
yet blessed by Debye and Huckel's light. Solutions that obeyed :eq:`eq_chemical_potential` were
characterized as *ideal* solutions since this equation applies to systems of noninteracting solute particles,
i.e, ideal particles. Electrolytic solutions that do not obey the equation were said to be *nonideal*. In order to use
an equation of the form of :eq:`eq_chemical_potential` to treat nonideal electrolytic solutions, an empirical
correction factor :math:`f_i` was introduced by Lewis as a modifier of the concentration term.

.. math::
    :label: eq_chemical_potential_correction

    \mu _i - \mu _i^0 = RT \ln x_i f_i 

It was argued that, in nonideal solutions, it was not just the analytical concentration
:math:`x_i` of species *i*, but its effective concentration :math:`x_i f_i` which determined the chemical-potential
change :math:`\mu _i - \mu _i ^0`. This effective concentration :math:`x_i f_i` was also known as the *activity*
:math:`a_i` of the species *i*, i.e.,

.. math::
    :label: eq_activity_definition

    a_i = x_i f_i

and the correction factor :math:`f_i`, as the *activity coefficient*. For ideal solutions, the activity coefficient
is unity, and the activity :math:`a_i` becomes identical to the concentration :math:`x_i`, i.e.,


.. math::
    :label: eq_activity_ideal_solution

    a_i = x_i \text{ when } f_i = 1

Thus, the chemical-potential change in going from the standard state to the final state can be written as 

.. math::
    :label: eq_chemical_potential_activity

    \mu _i - \mu _i ^0 = RT\ln x_i + RT \ln f_i

:eq:`eq_chemical_potential_activity` summarizes the empirical or formal treatment of the behavior of electrolytic
solutions. Such a treatment cannot furnish a theoretical expression for the acitivity coefficient :math:`f_i`.
It merely recognizes that expressions such as :eq:`eq_chemical_potential` must be modified if significant forces exist
between solute particules.

The physical significance of activity coefficients
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For a hypothetical system of ideal (noninteracting) particles, the chemical potential has been stated to be given by

.. math::
    :label: eq_chemical_potential_3_52

    \mu _i (ideal) = \mu _i ^0 + RT \ln x_i 

For a real system of interacting particles, the chemical potential has been expressed in
the form 

.. math:: 
    :label: eq_chemical_potential_3_57
    
    \mu _i (real) = \mu _i ^0 + RT \ln x_i + RT \ln f_i

Hence, to analyze the physical significance of the activity coefficient term in :eq:`eq_chemical_potential_3_57`
, it is necessary to compare this equation with :eq:`eq_chemical_potential_3_52`. It is obvious that when 
:eq:`eq_chemical_potential_3_52` is substracted from :eq:`eq_chemical_potential_3_57`, the difference is the 
chemical-potential change :math:`\Delta \mu _{i-I}` arising from the interactions between the solute particles
(ions in the case of electrolytic solutions). That is

.. math::
    :label: eq_chemical_potential_error_3_58

    \mu _i (real) - \mu _i (ideal) = \Delta \mu_{i-I}

and therefore,

.. math::
    :label: eq_chemical_potential_error_3_59

    \Delta \mu _{i-I} = RT \ln f_i

Thus, the activity coefficient is a measure of the chemical-potential change arising from ion-ion interactions.
There are several well-established methods of experimentally determining activity coefficients, and these methods are
treated in adequate details in standard treatises.

Now, according to the Debye-Huckel theory, the chemical-potential change :math:`\Delta \mu _{i-I}` arising 
from ion-ion interactions has been shown to be given by

.. math::
    :label: eq_chem_pot_change_3_51

    \Delta \mu _{i-I} = - \frac{N_A(z_i e_0)^2}{2 \epsilon \kappa ^{-1}}

Hence, combining :eq:`eq_chem_pot_change_3_51` and :eq:`eq_chemical_potential_error_3_58`, the result is


.. math::
    :label: eq_3_60

    RT \ln f_i = - \frac{N_A(z_i e_0)^2}{2 \epsilon \kappa ^{-1}}

Thus, the Debye-Huckel ionic-cloud model for ion-ion interactions has permitted a theoretical calculation
of activity coefficients resulting in :eq:`eq_3_60`.

The activity coefficient in :eq:`eq_chemical_potential_error_3_59` arises from the formula :eq:`eq_chemical_potential_3_57`
for the chemical potential, in which the concentration of the species *i* is expressed in mole fraction units :math:`x_i`.
One can also express the concentration in moles per liter of solution (molarity) or in moles per kilogram of solvent (molality).
Thus, alternative formulas for the chemical potential of a species *i* in an ideal solution read

.. math::
    :label: eq_3_61

    \mu _i = \mu _i^0 (c) + RT \ln c_i 

and

.. math::
    :label: eq_3_62

    \mu _i = \mu _i^0 (m) + RT \ln m_i 

where :math:`c_i` and :math:`m_i` are the molarity and molality of the species *i*, respectively, :math:`\mu _i^0(c)`
and :math:`\mu _i^0(m)` are the corresponding standard chemical potentials.

When the concentration of the ionic species in a real solution is expressed as molarity :math:`c_i` and molality :math:`m_i`
, there are corresponding activity coefficients :math:`\gamma _c` and :math:`\gamma _m` and corresponding expressions for :math:`\mu _i`

.. math::
    :label: eq_3_63

    \mu _i = \mu _i^0 (c) + RT \ln c_i + RT \ln \gamma _c


.. math::
    :label: eq_3_64

    \mu _i = \mu _i^0 (m) + RT \ln m_i + RT \ln \gamma _m


The activity coefficient of a single ionic species cannot be measured
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
