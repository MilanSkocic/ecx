/**
 * @file ecx_eis.h
 * @brief EIS C header for th ecx library.
 */
#ifndef ECX_EIS_H
#define ECX_EIS_H
#include "ecx_types.h"

extern void ecx_capi_zr(double *w, double R, size_t n, ecx_cdouble *Z);
extern void ecx_capi_zc(double *w, double C, size_t n, ecx_cdouble *Z);

#endif