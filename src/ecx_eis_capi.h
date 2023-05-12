/**
 * @file ecx_eis_capi.h
 * @brief EIS C header for th ecx library.
 * @details Complex impedance
 */
#ifndef ECX_EIS_CAPI_H
#define ECX_EIS_CAPI_H
#include "ecx_types.h"

extern void ecx_capi_zr(double *w, double R, size_t n, ecx_cdouble *Z);
extern void ecx_capi_zc(double *w, double C, size_t n, ecx_cdouble *Z);

#endif