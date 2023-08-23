#include "py_common.h"
#include "ecx_core.h"

const char ERR_MSG_ARGS_LAMBDA[] = "lambda is an object with the buffer protocol.";
const char ERR_MSG_LAMBDA_FORMAT[] = "lambda must be an array-like of floats.";
const char ERR_MSG_LAMBDA_DIM[] = "lambda must be an 1d-array of floats.";

PyDoc_STRVAR(module_docstring, "C extension wrapping the CORE module of the Fortran ecx library.");

PyDoc_STRVAR(nm2eV_doc, 
"nm2eV(lambda) --> memview \n\n"
"Convert wavelength in nm to energy in eV.");

static PyObject *nm2eV(PyObject *self, PyObject *args){

    PyObject *l_obj;
    
    double *l;
    double *E;
    PyObject *new_mview;
    PyObject *mview;
    Py_buffer *buffer;
    Py_buffer new_buffer;
    size_t n;


    if(!PyArg_ParseTuple(args, "O", &l_obj)){
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_LAMBDA);
        return NULL;
    }
    if(PyObject_CheckBuffer(l_obj)==1){
        mview = PyMemoryView_FromObject(l_obj);
        buffer = PyMemoryView_GET_BUFFER(mview);

        if(strcmp(buffer->format, "d")!=0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_LAMBDA_FORMAT);
            return NULL;
        }else if(buffer->ndim>1){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_LAMBDA_DIM);
            return NULL;
        }else if(buffer->ndim==0){
            PyErr_SetString(PyExc_TypeError, ERR_MSG_LAMBDA_DIM);
            return NULL;
        }else{
            new_buffer = create_new_buffer("d", sizeof(double), buffer->ndim, buffer->shape);
            l = (double *) buffer->buf;
            E = (double *) new_buffer.buf;
            n = buffer->shape[0];
            ecx_core_capi_nm2eV(l, E, n);
            new_mview = PyMemoryView_FromBuffer(&new_buffer);
            return new_mview;
        }
    }else{
        PyErr_SetString(PyExc_TypeError, ERR_MSG_ARGS_LAMBDA);
        return NULL;
    }

}

static PyMethodDef myMethods[] = {
    {"nm2eV", (PyCFunction) nm2eV, METH_VARARGS, nm2eV_doc},
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
PyMODINIT_FUNC PyInit_core(void)
{	
    PyObject *m;
	PyObject *d;
	PyObject *v;
	m = PyModule_Create(&core);
	d = PyModule_GetDict(m);

	v = PyFloat_FromDouble(ecx_core_capi_PI);
	PyDict_SetItemString(d, "PI", v);
	Py_INCREF(v);

    return m;
}


