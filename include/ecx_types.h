/**
 * @file ecx_types.h
 * @brief Type C header for th ecx library.
 * @details Compatibilty layer for handling complex numbers with MSC.
 * It is imported by all headers for each submodule.
 */
#ifndef ECX_TYPES_H
#define ECX_TYPES_H

#include <complex.h>
#if _MSC_VER
typedef _Dcomplex ecx_cdouble; /**< Cross platform complex type. */
#define ecx_cbuild(real, imag) (_Cbuild(real, imag))/**< Cross platform complex type constructor*/
#else
typedef double _Complex ecx_cdouble; /**< Cross platform complex type. */
#define ecx_cbuild(real, imag) (real+I*imag) /**< Cross platform complex type constructor*/
#endif

#endif