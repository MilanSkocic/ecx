/**
 * @file 
 * @brief C API - core
 */
#ifndef ECX_CORE_H
#define ECX_CORE_H
#if _MSC_VER
#define ADD_IMPORT __declspec(dllimport)
#else
#define ADD_IMPORT
#endif
#include "ecx_types.h"
ADD_IMPORT extern const double ecx_core_PI; /**< PI */
ADD_IMPORT extern const double ecx_core_T_K; /**< 0°C in Kelvin */
void ecx_core_nm2eV(double *lambda, double *E, size_t n); /**< Convert wavelength (nm) to energy (eV)*/
void ecx_core_kTe(double *U, double *kTE, size_t n); /**< Compute the thermal voltage (V) from temperature (°C)*/

#endif
