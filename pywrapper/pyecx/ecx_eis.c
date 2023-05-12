#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include "ecx_eis_capi.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the EIS module of the Fortran ecx library.");

PyDoc_STRVAR(zr_doc, 
"zr(w, R) --> memview \n\n"
"Computes the complex impedance for a resistor.");

PyDoc_STRVAR(zc_doc, 
"zc(w, C) --> float \n\n"
"Computes the complex impedance for a capacitor.");

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


static PyObject *zr(PyObject *self, PyObject *args){

    // arguments
    PyObject *w_obj;
    double r;
    // returns
    PyObject *new_mview;

    // variables 
    PyObject *mview;
    Py_buffer *buffer;
    Py_buffer new_buffer;


    if(!PyArg_ParseTuple(args, "Od", &w_obj, &r)){
        PyErr_SetString(PyExc_TypeError, "w is an object with the buffer protocol and R is a float.");
        return NULL;
    }

    if(PyObject_CheckBuffer(w_obj)==1){
        mview = PyMemoryView_FromObject(w_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, "w must be an array-like of floats.");
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, "w must be an 1d-array of floats.");
            return NULL;
        }else{
            new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
            ecx_capi_zr((double *)buffer->buf, r, buffer->shape[0], (ecx_cdouble *) new_buffer.buf);
            new_mview = PyMemoryView_FromBuffer(&new_buffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, "w must be an object with the buffer protocol such as numpy arrays.");
        return NULL;
    }

}

static PyObject *zc(PyObject *self, PyObject *args){

    // arguments
    PyObject *w_obj;
    double c;
    // returns
    PyObject *new_mview;

    // variables 
    PyObject *mview;
    Py_buffer *buffer;
    Py_buffer new_buffer;


    if(!PyArg_ParseTuple(args, "Od", &w_obj, &c)){
        PyErr_SetString(PyExc_TypeError, "w is an object with the buffer protocol and C is a float.");
        return NULL;
    }

    if(PyObject_CheckBuffer(w_obj)==1){
        mview = PyMemoryView_FromObject(w_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, "w must be an array-like of floats.");
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, "w must be an 1d-array of floats.");
            return NULL;
        }else{
            new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
            ecx_capi_zc((double *)buffer->buf, c, buffer->shape[0], (ecx_cdouble *) new_buffer.buf);
            new_mview = PyMemoryView_FromBuffer(&new_buffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, "w must be an object with the buffer protocol such as numpy arrays.");
        return NULL;
    }

}

static PyMethodDef myMethods[] = {
    {"zr", (PyCFunction) zr, METH_VARARGS, zr_doc},
    {"zc", (PyCFunction) zc, METH_VARARGS, zc_doc},
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


