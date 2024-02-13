/**
 * @file ecx_kinetics_capi.h
 * @brief KINETICS C header for th ecx library.
 * @details Kinetics
 */
#ifndef ECX_KINETICS_CAPI_H
#define ECX_KINETICS_CAPI_H
#include "ecx_types.h"
#include "ecx_core.h"

extern double ecx_kinetics_capi_nernst(double E0, int z, 
                                       double *aox, double *vox, size_t nox, 
                                       double *ared, double *vred, size_t nred, 
                                       double T);

extern void ecx_kinetics_capi_sbv(double *U, double OCV, double j0, 
                        double aa, double ac, double za, double zc,
                        double A, double T, double *i, size_t n);

extern void ecx_kinetics_capi_bv(double *U, double OCV, double j0, double jdla, double jdlc,
                        double aa, double ac, double za, double zc,
                        double A, double T, double *i, size_t n);

#endif