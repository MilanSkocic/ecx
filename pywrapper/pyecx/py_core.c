#include "py_common.h"
#include "ecx_core.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the CORE module of the Fortran ecx library.");

static PyMethodDef myMethods[] = {
    { NULL, NULL, 0, NULL }
};

// Our Module Definition struct
static struct PyModuleDef core = {
    PyModuleDef_HEAD_INIT,
    "core",
    module_docstring,
    -1,
    myMethods
};

// Initializes our module using our above struct
PyMODINIT_FUNC PyInit_eis(void)
{	
    PyObject *m;
	PyObject *d;
	PyObject *v;
	m = PyModule_Create(&core);
	d = PyModule_GetDict(m);

	v = PyFloat_FromDouble(ecx_PI);
	PyDict_SetItemString(d, "PI", v);
	Py_INCREF(v);

    return m;
}


