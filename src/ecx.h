/**
 * @file ecx.h
 * @brief C header for th ecx library.
 */
#ifndef ECX_H
#define ECX_H
#include <complex.h>
#if _MSC_VER
typedef _Dcomplex ecx_cdouble;
#define ecx_cbuild(real, imag) (_Cbuild(real, imag))
#else
typedef double _Complex ecx_cdouble;
#define ecx_cbuild(real, imag) (real+I*imag)
#endif
extern void ecx_capi_zr(double *w, double R, size_t n, ecx_cdouble *Z);






#endif