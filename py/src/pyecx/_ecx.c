#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include "ecx.h"

/* MODULE DOC *****************************************************************/
PyDoc_STRVAR(module_docstring, "C extension wrapping the Fortran ecx library.");


/* CORE DOC *******************************************************************/
PyDoc_STRVAR(nm2eV_doc, 
"nm2eV(lambda) --> memview \n\n"
"Convert wavelength in nm to energy in eV.");

PyDoc_STRVAR(kTe_doc, 
"kTe(T) --> memview \n\n"
"Compute the thermal voltage in Volts.");


/* EIS DOC ********************************************************************/
PyDoc_STRVAR(z_doc,
"z(e, w, p)-->memview\n\n"
"Compute the complex impedance of the element e.");


/* KINETICS DOC ***************************************************************/
PyDoc_STRVAR(sbv_doc, 
"sbv(OCV:float, U:array, j0:float, aa:float, ac:float, za:float, zc:float, A:float, T:float) --> memview \n\n"
"Compute Butler Volmer equation without mass transport.");


/* COMMON FUNCTIONS ***********************************************************/
Py_buffer create_new_buffer(char *format, Py_ssize_t itemsize, Py_ssize_t ndim, Py_ssize_t *shape){
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



/* CORE FUNCTIONS **************************************************************/
static PyObject *nm2eV(PyObject *self, PyObject *args){
    PyObject *l_obj;
    
    double *l;
    double *E;
    PyObject *mview;
    PyObject *new_mview;
    Py_buffer *buffer;
    Py_buffer new_buffer;
    size_t n;


    if(!PyArg_ParseTuple(args, "O", &l_obj)){
        PyErr_SetString(PyExc_TypeError, "wavelength must be an object with the buffer protocol.");
        return NULL;
    }
    mview = PyMemoryView_FromObject(l_obj);
    buffer = PyMemoryView_GET_BUFFER(mview);

    new_buffer = create_new_buffer("d", sizeof(double), buffer->ndim, buffer->shape);

    l = (double *) buffer->buf;
    E = (double *) new_buffer.buf;
    n = buffer->shape[0];
    ecx_core_nm2eV(l, E, n);

    new_mview = PyMemoryView_FromBuffer(&new_buffer);
    return new_mview;
}

static PyObject *kTe(PyObject *self, PyObject *args){
    PyObject *l_obj;
    
    double *T;
    double *kTe;
    PyObject *mview;
    PyObject *new_mview;
    Py_buffer *buffer;
    Py_buffer new_buffer;
    size_t n;


    if(!PyArg_ParseTuple(args, "O", &l_obj)){
        PyErr_SetString(PyExc_TypeError, "T must be an object with the buffer protocol.");
        return NULL;
    }
    mview = PyMemoryView_FromObject(l_obj);
    buffer = PyMemoryView_GET_BUFFER(mview);

    new_buffer = create_new_buffer("d", sizeof(double), buffer->ndim, buffer->shape);
    
    T = (double *) buffer->buf;
    kTe = (double *) new_buffer.buf;
    n = buffer->shape[0];
    ecx_core_kTe(T, kTe, n);
    
    new_mview = PyMemoryView_FromBuffer(&new_buffer);
    return new_mview;
}


/* EIS FUNCTIONS **************************************************************/
static PyObject *z(PyObject *self, PyObject *args){
    char * element;
    PyObject *w_obj;
    PyObject *p_obj;
    
    double *w;
    double *p;
    char e;
    ecx_cdouble *z;
    PyObject *w_mview;
    PyObject *p_mview;
    PyObject *new_mview;
    Py_buffer *buffer;
    Py_buffer *buffer_p;
    Py_buffer new_buffer;
    size_t k, n;
    int errstat;
    char *errmsg;


    if(!PyArg_ParseTuple(args, "sOO", &element, &w_obj, &p_obj)){
        PyErr_SetString(PyExc_TypeError, "e is a character, w and p are objects with the buffer protocol.");
        return NULL;
    }

    w_mview = PyMemoryView_FromObject(w_obj);
    p_mview = PyMemoryView_FromObject(p_obj);

    buffer = PyMemoryView_GET_BUFFER(w_mview);
    buffer_p = PyMemoryView_GET_BUFFER(p_mview);

    new_buffer = create_new_buffer("Zd", sizeof(ecx_cdouble), buffer->ndim, buffer->shape);
    w = (double *) buffer->buf;
    p = (double *) buffer_p->buf;
    e = element[0];
    z = (ecx_cdouble *) new_buffer.buf;
    k = buffer_p->shape[0];
    n = buffer->shape[0];
    ecx_eis_z(p, w, z, e, k, n, &errstat, &errmsg);
    new_mview = PyMemoryView_FromBuffer(&new_buffer);
    return new_mview;
}


/* KINETICS FUNCTIONS *********************************************************/
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
        PyErr_SetString(PyExc_TypeError, "U must be objects with the buffer protocol and all other parameter are floats.");
        return NULL;
    }

    mview = PyMemoryView_FromObject(U_obj);
    buffer = PyMemoryView_GET_BUFFER(mview);
        
    new_buffer = create_new_buffer("d", sizeof(double), buffer->ndim, buffer->shape);
    ecx_kinetics_sbv((double *)buffer->buf, OCV, j0, aa, ac, za, zc, A, T,
                                  (double *)new_buffer.buf, buffer->shape[0]);

    new_mview = PyMemoryView_FromBuffer(&new_buffer);
    return new_mview;
}


/* MODULE DEFINITION **********************************************************/
static PyMethodDef myMethods[] = {
    {"nm2eV", (PyCFunction) nm2eV, METH_VARARGS, nm2eV_doc},
    {"kTe", (PyCFunction) kTe, METH_VARARGS, kTe_doc},
    {"z", (PyCFunction) z, METH_VARARGS, z_doc},
    {"sbv", (PyCFunction) sbv, METH_VARARGS, sbv_doc},
    { NULL, NULL, 0, NULL }
};
static struct PyModuleDef _ecx = {PyModuleDef_HEAD_INIT, "_ecx", module_docstring, -1, myMethods};


/* MODULE INITIALIZATION ******************************************************/
PyMODINIT_FUNC PyInit__ecx(void)
{	
    PyObject *m;
    PyObject *d;
    PyObject *v;
	m = PyModule_Create(&_ecx);
    d = PyModule_GetDict(m);
    v = PyUnicode_FromFormat("%s", ecx_version());
    PyDict_SetItemString(d, "__version__", v);
    Py_INCREF(v);
    return m;
}

