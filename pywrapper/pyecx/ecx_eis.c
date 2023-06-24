#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include "ecx_eis_capi.h"

const char ERR_MSG_ARGS_R[] = "w is an object with the buffer protocol and R is a float.";
const char ERR_MSG_ARGS_C[] = "w is an object with the buffer protocol and C is a float.";
const char ERR_MSG_ARGS_L[] = "w is an object with the buffer protocol and L is a float.";
const char ERR_MSG_ARGS_CPE[] = "w is an object with the buffer protocol, Q and a are floats.";
const char ERR_MSG_ARGS_W[] = "w is an object with the buffer protocol and s is a float.";
const char ERR_MSG_ARGS_FLW[] = "w is an object with the buffer protocol, R and tau float.";
const char ERR_MSG_ARGS_FSW[] = "w is an object with the buffer protocol, R and tau float.";
const char ERR_MSG_ARGS_G[] = "w is an object with the buffer protocol, G and K float.";
const char ERR_MSG_WOBJ[] = "w must be an object with the buffer protocol such as numpy arrays.";
const char ERR_MSG_WFORMAT[] = "w must be an array-like of floats.";
const char ERR_MSG_WDIM[] = "w must be an 1d-array of floats.";

PyDoc_STRVAR(module_docstring, "C extension wrapping the EIS module of the Fortran ecx library.");

PyDoc_STRVAR(zr_doc, 
"zr(w, R) --> memview \n\n"
"Computes the complex impedance for a resistor.");

PyDoc_STRVAR(zc_doc, 
"zc(w, C) --> memview \n\n"
"Computes the complex impedance for a capacitor.");

PyDoc_STRVAR(zl_doc, 
"zl(w, L) --> memview \n\n"
"Computes the complex impedance for a inductor.");

PyDoc_STRVAR(zcpe_doc, 
"zcpe(w, Q, a) --> memview \n\n"
"Computes the complex impedance for a CPE.");

PyDoc_STRVAR(zw_doc, 
"zw(w, s) --> memview \n\n"
"Computes the complex impedance for a semi-infinite warburg.");

PyDoc_STRVAR(zflw_doc, 
"zflw(w, R, tau) --> memview \n\n"
"Computes the complex impedance for a finite length warburg.");

PyDoc_STRVAR(zfsw_doc, 
"zfsw(w, R, tau) --> memview \n\n"
"Computes the complex impedance for a finite space warburg.");

PyDoc_STRVAR(zg_doc, 
"zg(w, G, K) --> memview \n\n"
"Computes the complex impedance for a Gerisher element.");

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


static PyObject *zr(PyObject *self, PyObject *args){

    // arguments
    PyObject *w_obj;
    double p0; // R
    // returns
    PyObject *new_mview;

    // variables 
    PyObject *mview;
    Py_buffer *buffer;
    Py_buffer new_buffer;


    if(!PyArg_ParseTuple(args, "Od", &w_obj, &p0)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_R);
        return NULL;
    }

    if(PyObject_CheckBuffer(w_obj)==1){
        mview = PyMemoryView_FromObject(w_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WFORMAT);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WDIM);
            return NULL;
        }else{
            new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
            ecx_capi_zr((double *)buffer->buf, p0, buffer->shape[0], (ecx_cdouble *) new_buffer.buf);
            new_mview = PyMemoryView_FromBuffer(&new_buffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_WOBJ);
        return NULL;
    }

}

static PyObject *zc(PyObject *self, PyObject *args){

    // arguments
    PyObject *w_obj;
    double p0; //C
    // returns
    PyObject *new_mview;

    // variables 
    PyObject *mview;
    Py_buffer *buffer;
    Py_buffer new_buffer;


    if(!PyArg_ParseTuple(args, "Od", &w_obj, &p0)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_C);
        return NULL;
    }

    if(PyObject_CheckBuffer(w_obj)==1){
        mview = PyMemoryView_FromObject(w_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WFORMAT);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WDIM);
            return NULL;
        }else{
            new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
            ecx_capi_zc((double *)buffer->buf, p0, buffer->shape[0], (ecx_cdouble *) new_buffer.buf);
            new_mview = PyMemoryView_FromBuffer(&new_buffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_WOBJ);
        return NULL;
    }

}

static PyObject *zl(PyObject *self, PyObject *args){

    // arguments
    PyObject *w_obj;
    double p0; //L
    // returns
    PyObject *new_mview;

    // variables 
    PyObject *mview;
    Py_buffer *buffer;
    Py_buffer new_buffer;


    if(!PyArg_ParseTuple(args, "Od", &w_obj, &p0)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_L);
        return NULL;
    }

    if(PyObject_CheckBuffer(w_obj)==1){
        mview = PyMemoryView_FromObject(w_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WFORMAT);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WDIM);
            return NULL;
        }else{
            new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
            ecx_capi_zl((double *)buffer->buf, p0, buffer->shape[0], (ecx_cdouble *) new_buffer.buf);
            new_mview = PyMemoryView_FromBuffer(&new_buffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_WOBJ);
        return NULL;
    }

}

static PyObject *zcpe(PyObject *self, PyObject *args){

    // arguments
    PyObject *w_obj;
    double p0; // Q
    double p1; // a
    // returns
    PyObject *new_mview;

    // variables 
    PyObject *mview;
    Py_buffer *buffer;
    Py_buffer new_buffer;


    if(!PyArg_ParseTuple(args, "Odd", &w_obj, &p0, &p1)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_CPE);
        return NULL;
    }

    if(PyObject_CheckBuffer(w_obj)==1){
        mview = PyMemoryView_FromObject(w_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WFORMAT);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WDIM);
            return NULL;
        }else{
            new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
            ecx_capi_zcpe((double *)buffer->buf, p0, p1, buffer->shape[0], (ecx_cdouble *) new_buffer.buf);
            new_mview = PyMemoryView_FromBuffer(&new_buffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_WOBJ);
        return NULL;
    }

}

static PyObject *zw(PyObject *self, PyObject *args){

    // arguments
    PyObject *w_obj;
    double p0; //s
    // returns
    PyObject *new_mview;

    // variables 
    PyObject *mview;
    Py_buffer *buffer;
    Py_buffer new_buffer;


    if(!PyArg_ParseTuple(args, "Od", &w_obj, &p0)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_W);
        return NULL;
    }

    if(PyObject_CheckBuffer(w_obj)==1){
        mview = PyMemoryView_FromObject(w_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WFORMAT);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WDIM);
            return NULL;
        }else{
            new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
            ecx_capi_zw((double *)buffer->buf, p0, buffer->shape[0], (ecx_cdouble *) new_buffer.buf);
            new_mview = PyMemoryView_FromBuffer(&new_buffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_WOBJ);
        return NULL;
    }

}

static PyMethodDef myMethods[] = {
    {"zr", (PyCFunction) zr, METH_VARARGS, zr_doc},
    {"zc", (PyCFunction) zc, METH_VARARGS, zc_doc},
    {"zl", (PyCFunction) zl, METH_VARARGS, zl_doc},
    {"zcpe", (PyCFunction) zcpe, METH_VARARGS, zcpe_doc},
    {"zw", (PyCFunction) zw, METH_VARARGS, zw_doc},
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


