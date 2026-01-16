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


ADD_IMPORT extern const double ecx_core_PI; 
ADD_IMPORT extern const double ecx_core_T_K; 
extern void ecx_core_nm2eV(double *lambda, double *E, size_t n); 
extern void ecx_core_kTe(double *T, double *kTE, size_t n); 


extern double ecx_kinetics_nernst(double E0, int z, 
                                       double *aox, double *vox, size_t nox, 
                                       double *ared, double *vred, size_t nred, 
                                       double T);

extern void ecx_kinetics_sbv(double *U, double OCV, double j0, 
                                  double aa, double ac, double za, double zc,
                                  double A, double T, double *i, size_t n);

extern void ecx_kinetics_bv(double *U, double OCV, double j0, double jdla, double jdlc,
                        double aa, double ac, double za, double zc,
                        double A, double T, double *i, size_t n);


extern void ecx_eis_z(double *p, double *w, ecx_cdouble *z, 
                      char e, size_t k, size_t n, 
                      int *errstat, char *(*errmsg)); 

#endif


