/** 
 * @file electrox.h
 *
 * @brief Header of the library libelectox.
 *
 * @details API contains:
 *
 * Copyright (C) 2020-2021  Milan Skocic.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>. 
 *
 * Author: Milan Skocic <milan.skocic@gmail.com>
 *
 */

#ifndef ELECTROX_H
#define ELECTROX_H

/**
 * @file electrox.h
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <complex.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_complex.h>
#include <gsl/gsl_complex_math.h>
#include <gsl/gsl_const_mksa.h>
#include <gsl/gsl_vector.h>
#define T_K 273.15                        /**< Conversion offset from degree Celsius to degree Kelvin  */
#define kB GSL_CONST_MKSA_BOLTZMANN       /**< Boltzmann Constant */
#define qe GSL_CONST_MKSA_ELECTRON_CHARGE /**< Elementary charge */




/* utilities */
double get_kTe(double temperature, int mV);
double roundn(double x, int n);
double round_error(double x);
double round_significant(double x, int n);
double round_value(double x, double dx);
int assert_equal(double a, double b, int n);




/********** kinetics **********/
double sbv(double OCV, double U, double j0,
           double aa, double ac, double za, double zc,
           double S, double T);
double bv(double OCV, double U, double j0, double jdla, double jdlc,
          double aa, double ac, double za, double zc,
          double S, double T);



/* io */
int read_z(char *fpath, int verbose);




/* EIS functions */

/**
 * @brief Element types 
 * @details Availables types are R, L, C, W, Wd, Wm.
 * R = Resistor
 * L = Inductor
 * C = Capacitor
 * Q = Constant Phase Element
 * W = Semi-infinite warburg
 * Wd or Ws or O = Finite Length Warburg (Short Warburg)
 * Wm or Wo or T = Finite Space Warburg (Open Warburg)
 * 
 */
typedef enum
{
    R,
    L,
    C,
    Q,
    W,
    Wd,
    Ws,
    O,
    Wm,
    Wo,
    T
} ElementType;

double complex resistance(double r, double w);
void gsl_resistance(gsl_vector *p, gsl_vector *w, gsl_vector_complex *Z);

double complex capacitance(double c, double w);
void gsl_capacitance(gsl_vector *p, gsl_vector *w, gsl_vector_complex *Z);

double complex inductance(double l, double w);
void gsl_inductance(gsl_vector *p, gsl_vector *w, gsl_vector_complex *Z);

double complex warburg(double sigma, double w);

double complex finite_space_warburg(double r, double tau, double w);

double complex finite_length_warburg(double r, double tau, double w);

/* Structures */
/**
 * @brief structure representing an EIS element
 * @details details
 */
typedef struct eis_element
{
    char *name;       /**< Name */
    ElementType type; /**< type */
    gsl_vector *p;    /**< parameters */

    /* Methods */
    void (*__init__)(struct eis_element *self, char *name, ElementType type); /**< Initialization */
    void (*__del__)(struct eis_element *self);                                /**< Destructor */
    void (*Z)(gsl_vector *p, gsl_vector *w, gsl_vector_complex *z);           /**< Compute impedance*/
} EisElement;

/**
 * @brief Eis circuit structure
 * @details Structured representation of a equivalent circuit.
 */
typedef struct eis_circuit
{
    char *name;            /**< EIS Circuit name */
    char *repr;            /**< Eis Representation */
    EisElement **elements; /**< Eis Elements of the circuit*/
} EisCircuit;

/* Struct methods */
EisElement *EisElement__new__(char *name, ElementType type);
void EisElement__init__(EisElement *self, char *name, ElementType type);
void EisElement__del__(EisElement *self);

EisCircuit *EisCircuit__new__(char *name, char *repr);
void EisCircuit__init__(EisCircuit *self, char *name, char *repr);

#endif
