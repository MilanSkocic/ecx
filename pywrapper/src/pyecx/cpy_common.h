#ifndef PY_COMMON_H
#define PY_COMMON_H
Py_buffer create_new_buffer(char *format, Py_ssize_t itemsize, Py_ssize_t ndim, Py_ssize_t *shape);
Py_buffer *get_buffer(PyObject *o);
#endif