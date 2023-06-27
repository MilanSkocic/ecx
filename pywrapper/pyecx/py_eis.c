#include "py_common.h"
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

// common pointer for RCL elements.
static void (*fp_zrcl)(double *w, double p, size_t n, ecx_cdouble *Z);

static Py_buffer *get_buffer(PyObject *o){

    PyObject *mview;
    Py_buffer *buffer;

    if(PyObject_CheckBuffer(o)==1){
        mview = PyMemoryView_FromObject(o);
        buffer = PyMemoryView_GET_BUFFER(mview);
    
        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WFORMAT);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WDIM);
            return NULL;
        }else if(buffer->ndim==0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WDIM);
            return NULL;
        }else{
            return buffer;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_WOBJ);
        return NULL;
    }
}

static PyObject *zrcl(PyObject *o, char element, double p0){

    Py_buffer *buffer;
    Py_buffer new_buffer;
    PyObject *new_mview;

    switch(element){
        case 'R':
            fp_zrcl = &ecx_capi_zr;
            break;
        case 'C':
            fp_zrcl = &ecx_capi_zc;
            break;
        case 'L':
            fp_zrcl = &ecx_capi_zl;
            break;
        default:
            fp_zrcl = &ecx_capi_zr;
            break;
    }

    buffer = get_buffer(o);
    if(buffer != NULL){
        new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
        fp_zrcl((double *)buffer->buf, p0, buffer->shape[0], (ecx_cdouble *) new_buffer.buf);
        new_mview = PyMemoryView_FromBuffer(&new_buffer);
        return new_mview;
    }else{
        return NULL;
    }
}


static PyObject *zr(PyObject *self, PyObject *args){
    PyObject *w_obj;
    double p0; // R
    if(!PyArg_ParseTuple(args, "Od", &w_obj, &p0)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_R);
        return NULL;
    }
    return zrcl(w_obj, 'R', p0);
}

static PyObject *zc(PyObject *self, PyObject *args){
    PyObject *w_obj;
    double p0;
    if(!PyArg_ParseTuple(args, "Od", &w_obj, &p0)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_R);
        return NULL;
    }
    return zrcl(w_obj, 'C', p0);
}

static PyObject *zl(PyObject *self, PyObject *args){
    PyObject *w_obj;
    double p0;
    if(!PyArg_ParseTuple(args, "Od", &w_obj, &p0)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_R);
        return NULL;
    }
    return zrcl(w_obj, 'L', p0);
}

static PyObject *zcpe(PyObject *self, PyObject *args){

    // arguments
    PyObject *w_obj;
    double p0; // Q
    double p1; // a
    // returns
    PyObject *new_mview;

    // variables 
    Py_buffer *buffer;
    Py_buffer new_buffer;


    if(!PyArg_ParseTuple(args, "Odd", &w_obj, &p0, &p1)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_CPE);
        return NULL;
    }
    buffer = get_buffer(w_obj);
    if(buffer != NULL){
        new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
        ecx_capi_zcpe((double *)buffer->buf, p0, p1, buffer->shape[0], (ecx_cdouble *) new_buffer.buf);
        new_mview = PyMemoryView_FromBuffer(&new_buffer);
        return new_mview;
    }else{
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

static PyObject *z(PyObject *self, PyObject *args){

    char * element;
    PyObject *w_obj;
    PyObject *p_obj;
    
    double *w;
    double *p;
    char e;
    ecx_cdouble *z;
    PyObject *new_mview;
    PyObject *mview;
    PyObject *mview_p;
    Py_buffer *buffer;
    Py_buffer *buffer_p;
    Py_buffer new_buffer;
    size_t k, n;


    if(!PyArg_ParseTuple(args, "sOO", &element, &w_obj, &p_obj)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_CPE);
        return NULL;
    }

    if(PyObject_CheckBuffer(w_obj)==1){
        mview = PyMemoryView_FromObject(w_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);
        mview_p = PyMemoryView_FromObject(p_obj);
        buffer_p = PyMemoryView_GET_BUFFER(mview_p);

        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WFORMAT);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WDIM);
            return NULL;
        }else if(buffer->ndim==0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_WDIM);
            return NULL;
        }else{
            new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
            w = (double *) buffer->buf;
            p = (double *) buffer_p->buf;
            e = element[0];
            z = (ecx_cdouble *) new_buffer.buf;
            k = buffer_p->shape[0];
            n = buffer->shape[0];
            ecx_eis_capi_z(e, p, w, z, k, n);
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
    {"z", (PyCFunction) z, METH_VARARGS, NULL},
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


