NAME
----

**ecxcli(1)** - Command line for ecx

SYNOPSIS
--------

::

   ecxcli SUBCOMMAND [OPTIONS ...] ARGS ...

DESCRIPTION
-----------

**ecxcli is command line interface for computing electro-** chemical
properties:

   **o EIS**
      Electrochemical Impedance **Z=f(w)**

   **o Kinetics**
      **j=f(U)**

   **o PEC**
      **Iph=f(hv, U)**

It can also provide the molar masses, isotope compositions and nuclide
compositions.

SUBCOMMANDS
-----------

**o all**
   Get the whole periodic table.

**o saw**
   Get the standard atomic weight.

Enter **ecxcli** *SUBCOMMAND* **--help for detailed descriptions.**

OPTIONS
-------

**o --abridged, -a**
   Use the abridged value.

**o --uncertainty, -u**
   Use the uncertainty.

**o --pprint**
   Nice formatting.

**o --mass, -z**
   Get the mass number.

VALID FOR ALL SUBCOMMANDS
-------------------------

**o --help**
   Show help text and exit

**o --verbose**
   Display additional information when available.

**o --version**
   Show version information and exit.
