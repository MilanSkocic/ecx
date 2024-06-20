#ifndef ECX_H
#define ECX_H
#include <complex.h>
#if _MSC_VER
    #define ADD_IMPORT __declspec(dllimport)
    typedef _Dcomplex ecx_cdouble; 
    #define ecx_cbuild(real, imag) (_Cbuild(real, imag))
#else
    #define ADD_IMPORT
    typedef double _Complex ecx_cdouble; 
    #define ecx_cbuild(real, imag) (real+I*imag) 
#endif

extern char* ecx_get_version(void);


/* ---------------------------------------------------------------------------------------------- */
ADD_IMPORT extern const double ecx_core_PI; 
ADD_IMPORT extern const double ecx_core_T_K; 
void ecx_core_nm2eV(double *lambda, double *E, size_t n); 
void ecx_core_kTe(double *U, double *kTE, size_t n); 
/* ---------------------------------------------------------------------------------------------- */


/* ---------------------------------------------------------------------------------------------- */
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
/* ---------------------------------------------------------------------------------------------- */


/* ---------------------------------------------------------------------------------------------- */
extern void ecx_capi_zr(double *w, double R, size_t n, ecx_cdouble *Z);
extern void ecx_capi_zc(double *w, double C, size_t n, ecx_cdouble *Z);
extern void ecx_capi_zl(double *w, double L, size_t n, ecx_cdouble *Z);
extern void ecx_capi_zcpe(double *w, double Q, double a, size_t n, ecx_cdouble *Z);
extern void ecx_capi_zw(double *w, double s, size_t n, ecx_cdouble *Z);
extern void ecx_eis_z(double *p, double *w, ecx_cdouble *z, 
                      char e, size_t k, size_t n, 
                      int *errstat, char *(*errmsg)); 
/* ---------------------------------------------------------------------------------------------- */

#endif


