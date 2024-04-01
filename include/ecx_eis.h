/**
 * @file 
 * @brief EIS C header for the ecx library.
 * @details Complex impedance
 */
#ifndef ECX_EIS_CAPI_H
#define ECX_EIS_CAPI_H
#include "ecx_types.h"
#include "ecx_core.h"

extern void ecx_capi_zr(double *w, double R, size_t n, ecx_cdouble *Z);
extern void ecx_capi_zc(double *w, double C, size_t n, ecx_cdouble *Z);
extern void ecx_capi_zl(double *w, double L, size_t n, ecx_cdouble *Z);
extern void ecx_capi_zcpe(double *w, double Q, double a, size_t n, ecx_cdouble *Z);
extern void ecx_capi_zw(double *w, double s, size_t n, ecx_cdouble *Z);

/**
 * @brief C API Compute the complex impedance for the given element.
 * @param[in] n Size of w
 * @param[in] k Size of p
 * @param[in] e Electrochemical element: R, C, L, Q, O, T, G
 * @param[in] errstat Error status
 * @param[in] p Parameters.
 * @param[in] w Angular frequencies in rad.s-1
 * @param[in] z Complex impedance in Ohms.
 */
extern void ecx_eis_z(double *p, double *w, ecx_cdouble *z, char e, size_t k, size_t n, int *errstat); 

#endif
