
The library is built with `fpm <https://fpm.fortran-lang.org/en/index.html>`_ which will
build the fortran code into a static library.
An Makefile is provided which uses fpm with additional options for:

* copy the library into the python wrapper folder
* install the C headers 
* uninstall the librariy and headers

On windows, `msys2 <https://www.msys2.org>`_ needs to be installed. 


Build

.. code-block:: bash

    source configuration
    make

Run tests

.. code-block:: bash
    
    fpm test

Install
    
.. code-block:: bash
    
    make install

Uninstall

.. code-block:: bash

    make uninstall