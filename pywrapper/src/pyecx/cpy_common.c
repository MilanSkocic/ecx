#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include "cpy_common.h"

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

Py_buffer *get_buffer(PyObject *o){

    PyObject *mview;
    Py_buffer *buffer;

    if(PyObject_CheckBuffer(o)==1){
        mview = PyMemoryView_FromObject(o);
        buffer = PyMemoryView_GET_BUFFER(mview);
    
        if(strcmp(buffer->format, "d")!=0){
            return NULL;
        }else if(buffer->ndim>1){
            return NULL;
        }else if(buffer->ndim==0){
            return NULL;
        }else{
            return buffer;
        }
    }else{
        return NULL;
    }
}
