#include "py_common.h" 


Py_buffer create_new_buffer(char *format,
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