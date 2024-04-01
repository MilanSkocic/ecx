#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include "ecx.h"
#include "cpy_common.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the EIS module of the Fortran ecx library.");

PyDoc_STRVAR(z_doc,
"z(e, w, p)-->memview\n\n"
"Compute the complex impedance of the element e.");

static PyObject *z(PyObject *self, PyObject *args){

    char * element;
    PyObject *w_obj;
    PyObject *p_obj;
    
    double *w;
    double *p;
    char e;
    ecx_cdouble *z;
    PyObject *new_mview;
    Py_buffer *buffer;
    Py_buffer *buffer_p;
    Py_buffer new_buffer;
    size_t k, n;
    int errstat;


    if(!PyArg_ParseTuple(args, "sOO", &element, &w_obj, &p_obj)){
        PyErr_SetString(PyExc_TypeError, "e is a character, w and p are objects with the buffer protocol.");
        return NULL;
    }
    buffer = get_buffer(w_obj);
    buffer_p = get_buffer(p_obj);
    if((buffer != NULL) & (buffer_p != NULL)){
        new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
        w = (double *) buffer->buf;
        p = (double *) buffer_p->buf;
        e = element[0];
        z = (ecx_cdouble *) new_buffer.buf;
        k = buffer_p->shape[0];
        n = buffer->shape[0];
        ecx_eis_z(p, w, z, e, k, n, &errstat);
        new_mview = PyMemoryView_FromBuffer(&new_buffer);
        return new_mview;
    }else{
        PyErr_SetString(PyExc_TypeError, "w and p are objects with a 1d buffer protocol of type float.");
        return NULL;
    }

}

static PyMethodDef myMethods[] = {
    {"z", (PyCFunction) z, METH_VARARGS, z_doc},
    { NULL, NULL, 0, NULL }
};

// Our Module Definition struct
static struct PyModuleDef eis = {
    PyModuleDef_HEAD_INIT,
    "eis",
    module_docstring,
    -1,
    myMethods
};

// Initializes our module using our above struct
PyMODINIT_FUNC PyInit_eis(void)
{
    return PyModule_Create(&eis);
}


