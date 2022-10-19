/**
 * @file eis.h
 * 
 * @brief Declaration of Fortran functions.
 * 
 * @details External link to the fortran functions used in the C wrappers.
 * 
 */
#ifndef EIS_H
#define EIS_H
#include <stdlib.h>
#include <complex.h>

void impedance_resistance_(double *w, double *R, size_t *N, double complex *Z);

#endif