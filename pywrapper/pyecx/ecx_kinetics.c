#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include "ecx_kinetics_capi.h"

const char ERR_MSG_ARGS[] = "U must be objects with the buffer protocol and all other parameter are floats.";
const char ERR_MSG_U_OBJ[] = "U must be an object with the buffer protocol such as numpy arrays.";
const char ERR_MSG_U_FORMAT[] = "U must be an array-like of floats.";
const char ERR_MSG_U_DIM[] = "U must be an 1d-array of floats.";

PyDoc_STRVAR(module_docstring, "C extension wrapping the KINETICS module of the Fortran ecx library.");


PyDoc_STRVAR(sbv_doc, 
"sbv(OCV:float, U:array, j0:float, aa:float, ac:float, za:float, zc:float, A:float, T:float) --> memview \n\n"
"Compute Butler Volmer equation without mass transport.");

static Py_buffer create_new_buffer(const char *format,
                                   Py_ssize_t itemsize, 
                                   Py_ssize_t ndim,
                                   Py_ssize_t *shape){

    Py_buffer buffer;
    Py_ssize_t i, j, size, subsize;
    Py_ssize_t *strides = (Py_ssize_t *)PyMem_Calloc(ndim, sizeof(Py_ssize_t));

    buffer.obj = NULL;
    buffer.suboffsets = NULL;
    buffer.format = format;
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

static PyObject *sbv(PyObject *self, PyObject *args){

    // arguments
    PyObject *U_obj;
    double OCV, j0, aa, ac, za, zc, A, T;
    // returns
    PyObject *new_mview;

    // variables 
    PyObject *mview;
    Py_buffer *buffer;
    Py_buffer new_buffer;


    if(!PyArg_ParseTuple(args, "Odddddddd", &U_obj, OCV, j0, aa, ac, za, zc, A, T)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS);
        return NULL;
    }

    if(PyObject_CheckBuffer(U_obj)==1){
        mview = PyMemoryView_FromObject(U_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_U_FORMAT);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_U_DIM);
            return NULL;
        }else{
            new_buffer = create_new_buffer("d", sizeof(double), buffer->ndim, buffer->shape);
            ecx_kinetics_capi_sbv((double *)buffer->buf, OCV, j0, aa, ac, za, zc, A, T,
                                  (double *)new_buffer->buf, buffer->shape[0]);
            new_mview = PyMemoryView_FromBuffer(&new_buffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_U_OBJ);
        return NULL;
    }

}
