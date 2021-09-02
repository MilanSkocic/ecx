/** 
 * @file test_eis.c
 *
 * @brief Tests EIS.
 *
 * @details Different tests where computed vs expected values are displayed.
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

#include <stdlib.h>
#include <stdio.h>
#include "electrox.h"

/**
 * @brief EIS test.
 */
int main(int argc, char **argv)
{

    double complex expected;
    double complex computed;

    double r, c, l, s, f, w, tau;

    printf("\n");
    printf("***** TESTING EIS *****");
    printf("\n");

    /* Resistance */
    r = 100.0;
    f = 1.0;
    w = 2 * M_PI * f;
    computed = resistance(r, w);
    expected = 100.0;
    printf("\t--> resistance\n");
    printf("\tComputed/Expected=%.3e+j%.3e / %.3e+j%.3e\n", creal(computed), cimag(computed), creal(expected), cimag(expected));

    /* Capacitance */
    c = 1.0e-6;
    f = 0.1;
    w = 2 * M_PI * f;
    computed = capacitance(c, w);
    expected = 1.0 / (I * c * w);
    printf("\t--> capacitance\n");
    printf("\tComputed/Expected=%.3e+j%.3e / %.3e+j%.3e\n", creal(computed), cimag(computed), creal(expected), cimag(expected));

    /* Inductance */
    l = 1.0e-6;
    f = 0.1;
    w = 2 * M_PI * f;
    computed = inductance(l, w);
    expected = I * l * w;
    printf("\t--> inductance\n");
    printf("\tComputed/Expected=%.3e+j%.3e / %.3e+j%.3e\n", creal(computed), cimag(computed), creal(expected), cimag(expected));

    /* Warburg */
    s = 1000;
    f = 0.001;
    w = 2 * M_PI * f;
    computed = warburg(s, w);
    expected = s / sqrt(w) * (1 - I);
    printf("\t--> Semi-Infinite Warburg\n");
    printf("\tComputed/Expected=%.3e+j%.3e / %.3e+j%.3e\n", creal(computed), cimag(computed), creal(expected), cimag(expected));

    /* Finite Length Warburg */
    s = 1000;
    f = 0.001;
    tau = 10.0;
    w = 2 * M_PI * f;
    computed = finite_length_warburg(s, tau, w);
    expected = s / csqrt(I * w * tau) * ctanh(csqrt(I * w * tau));
    printf("\t--> Finite Length Warburg\n");
    printf("\tComputed/Expected=%.3e+j%.3e / %.3e+j%.3e\n", creal(computed), cimag(computed), creal(expected), cimag(expected));

    /* Finite Space Warburg */
    s = 1000;
    f = 0.001;
    tau = 10.0;
    w = 2 * M_PI * f;
    computed = finite_space_warburg(s, tau, w);
    expected = s / (csqrt(I * w * tau) * ctanh(csqrt(I * w * tau)));
    printf("\t--> Finite Space Warburg\n");
    printf("\tComputed/Expected=%.3e+j%.3e / %.3e+j%.3e\n", creal(computed), cimag(computed), creal(expected), cimag(expected));

    int i;
    int N = 3;
    char *name = "circuit";
    char *repr = "Rel+Rct";
    element_type type = R;
    EisCircuit *cc = EisCircuit__new__(name, repr);
    EisElement *e = EisElement__new__(name, type);

    printf("cc->name: %s\n", cc->name);
    printf("cc->name: %s\n", cc->repr);
    printf("e->name: %s\n", e->name);

    for (i = 0; i < N; i++)
    {
        printf("\tcc->elements[%d]->name: %s\n", i, cc->elements[i]->name);
    }

    return EXIT_SUCCESS;
}
