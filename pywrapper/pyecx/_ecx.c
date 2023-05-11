#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <complex.h>
#include "ecx.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the Fortran ecx library.");

PyDoc_STRVAR(ecx_zr_doc, 
"zr(w, R) --> float \n\n"
"Get the complex impedance for a resistor.");

static Py_buffer create_new_buffer(const char *format,
                                   Py_ssize_t itemsize, 
                                   Py_ssize_t ndim,
                                   Py_ssize_t *shape){

    Py_buffer buffer;
    Py_ssize_t i, j, size, subsize;
    Py_ssize_t *strides = (Py_ssize_t *)PyMem_Calloc(ndim, sizeof(Py_ssize_t));

    buffer.obj = NULL;
    buffer.suboffsets = NULL;
    buffer.format = "Zd";
    buffer.readonly = 0;
    buffer.itemsize = itemsize;
    buffer.ndim = ndim;
    buffer.shape = shape;

    size = 1;
    for(i=0; i<ndim; i++){
        size *= shape[i];
    }

    strides[ndim-1] = itemsize;
    printf("elmtsize=%ld\n", itemsize);
    if(ndim > 1){
        for(i=0; i<(ndim-1); i++){
            subsize = 1;
            for(j=i+1; j<ndim; j++){
                subsize *= shape[j];
            }
            strides[i] = subsize * itemsize;
        }
    }

    buffer.len = size * itemsize;
    buffer.strides = strides;
    buffer.buf = PyMem_Calloc(size, itemsize);

    return buffer;

}


static PyObject *_ecx_zr(PyObject *self, PyObject *args){

    PyObject *w_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer new_buffer;

    double r;
    double w;
    ecx_cdouble z = ecx_cbuild(0.0, 0.0);

    if(!PyArg_ParseTuple(args, "Od", &w_obj, &r)){
        PyErr_SetString(PyExc_TypeError, "w is a float or a 1d-array like, r is a float.");
        return NULL;
    }

    if(PyFloat_Check(w_obj) == 1){
        w = PyFloat_AsDouble(w_obj);
        ecx_capi_zr(&w, r, 1, &z);
        return PyComplex_FromDoubles(creal(z), cimag(z));
    }else if(PyLong_Check(w_obj)==1){
        w = PyFloat_AsDouble(w_obj);
        ecx_capi_zr(&w, r, 1, &z);
        return PyComplex_FromDoubles(creal(z), cimag(z));
    }else if(PyObject_CheckBuffer(w_obj)==1){
        mview = PyMemoryView_FromObject(w_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, "w must be an array-like of floats.");
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, "w must be an rank-1 of floats.");
            return NULL;
        }else{
            new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
            ecx_capi_zr((double *)buffer->buf, r, buffer->shape[0], (ecx_cdouble *) new_buffer.buf);
            new_mview = PyMemoryView_FromBuffer(&new_buffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, "w must be an int, a float or a array-like of floats");
        return NULL;
    }

}


static PyMethodDef myMethods[] = {
    {"zr", (PyCFunction) _ecx_zr, METH_VARARGS, ecx_zr_doc},
    { NULL, NULL, 0, NULL }
};

// Our Module Definition struct
static struct PyModuleDef _ecx = {
    PyModuleDef_HEAD_INIT,
    "_ecx",
    module_docstring,
    -1,
    myMethods
};

// Initializes our module using our above struct
PyMODINIT_FUNC PyInit__ecx(void)
{
    return PyModule_Create(&_ecx);
}


