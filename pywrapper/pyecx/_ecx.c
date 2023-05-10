#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <complex.h>
#include "ecx.h"

PyDoc_STRVAR(module_docstring, "C extension wrapping the Fortran ecx library.");

PyDoc_STRVAR(ecx_zr_doc, 
"zr(w, R) --> float \n\n"
"Get the complex impedance for a resistor.");


static PyObject *_ecx_zr(PyObject *self, PyObject *args){

    PyObject *w_obj;
    PyObject *mview;
    Py_buffer *buffer;
    PyObject *new_mview;
    Py_buffer new_buffer;

    double r;
    double w;
    ecx_cdouble z = ecx_cbuild(0.0, 0.0);
    Py_ssize_t i;

    if(!PyArg_ParseTuple(args, "Od", &w_obj, &r)){
        PyErr_SetString(PyExc_TypeError, "w is a float or a 1d-array like, r is a float.");
        return NULL;
    }

    if(PyFloat_Check(w_obj) == 1){
        w = PyFloat_AsDouble(w_obj);
        ecx_capi_zr(&w, r, 1, &z);
        return Py_BuildValue("D", z);
    }else if(PyLong_Check(w_obj)==1){
        ecx_capi_zr(&w, r, 1, &z);
        return Py_BuildValue("D", z);
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

            new_buffer.buf = PyMem_Calloc(buffer->len, sizeof(ecx_cdouble));
            new_buffer.obj = NULL;
            new_buffer.len = buffer->len;
            new_buffer.readonly = buffer->readonly;
            new_buffer.itemsize = buffer->itemsize;
            new_buffer.format = "Zd";
            new_buffer.ndim = buffer->ndim;
            new_buffer.shape = buffer->shape;
            new_buffer.strides = buffer->strides;
            new_buffer.suboffsets = NULL;

            for(i=0; new_buffer.ndim; i++){
                new_buffer.strides[i] *= 2;
            }
            
            ecx_capi_zr((double *)buffer->buf, r, buffer->len, (ecx_cdouble *) new_buffer.buf);
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


