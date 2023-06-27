#ifndef PY_COMMON_H
#define PY_COMMON_H
#define PY_SSIZE_T_CLEAN
#include <Python.h>
Py_buffer create_new_buffer(char *format, Py_ssize_t itemsize, Py_ssize_t ndim, Py_ssize_t *shape);
#endif