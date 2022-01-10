/** 
 * @file test_bv.c
 *
 * @brief Tests Butler Volmer.
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
 * @brief Main test suite.
 */
int main(int argc, char **argv)
{
    double OCV = 0.0;
    double U = 0.0;
    double j0 = 1e-6;
    double jdla = 1e6;
    double jdlc = 1e6;
    double aa = 0.5;
    double ac = 0.5;
    double za = 1;
    double zc = 1;
    double S = 1.0;
    double T = 25.0;

    size_t i;
    size_t n = 1e8;

    double *x;

    double computed;
    double expected;
    int equal;

    printf("\n");
    printf("***** TESTING BUTLER-VOLMER *****");
    printf("\n");

    printf("%s\n", "test at U - OCV = 0.0V");
    computed = bv(OCV, U, j0, jdla, jdlc, aa, ac, za, zc, S, T);
    expected = 0.000;
    printf("\tComputed/Expected=%.6e/%.6e\n", computed, expected);
    equal = assert_equal(computed, expected, 3);
    if (!equal)
    {
        return EXIT_FAILURE;
    }

    printf("%s\n", "test at U - OCV = 0.2V");
    U = 0.2;
    computed = bv(OCV, U, j0, jdla, jdlc, aa, ac, za, zc, S, T);
    expected = 4.8997e-5;
    printf("\tComputed/Expected=%.6e/%.6e\n", computed, expected);
    equal = assert_equal(computed * 1e5, expected * 1e5, 3);
    if (!equal)
    {
        return EXIT_FAILURE;
    }

    printf("%s\n", "test at U - OCV = 0.2V and S=2.321");
    U = 0.2;
    S = 2.321;
    computed = bv(OCV, U, j0, jdla, jdlc, aa, ac, za, zc, S, T);
    expected = 4.8997e-5 * S;
    printf("\tComputed/Expected=%.6e/%.6e\n", computed, expected);
    equal = assert_equal(computed * 1e5, expected * 1e5, 3);
    if (!equal)
    {
        return EXIT_FAILURE;
    }
    
    printf("%s\n", "Test Nernst equation");
    double Eo = 0.0;
    n = 1;
    gsl_vector *Cox = gsl_vector_alloc(n);
    gsl_vector *Cred = gsl_vector_alloc(n);
    gsl_vector *aox = gsl_vector_alloc(n);
    gsl_vector *ared = gsl_vector_alloc(n);

    gsl_vector_set_all(Cox, 1.0);
    gsl_vector_set_all(Cred, 1.0);
    gsl_vector_set_all(aox, 1.0);
    gsl_vector_set_all(ared, 1.0);

    computed = nernst(Eo, Cox, aox, Cred, ared, 25.0);
    expected = 0.00;
    printf("\tComputed/Expected=%.6e/%.6e\n", computed, expected);
    equal = assert_equal(computed, expected, 2);

    Eo = 0.10;
    computed = nernst(Eo, Cox, aox, Cred, ared, 25.0);
    expected = 0.10;
    printf("\tComputed/Expected=%.6e/%.6e\n", computed, expected);
    equal = assert_equal(computed, expected, 2);
    
    Eo = 0.00;
    gsl_vector_set_all(Cox, 10.0);
    computed = nernst(Eo, Cox, aox, Cred, ared, 25.0);
    expected = 0.00 + get_kTe(25.0, 0) * log(pow(gsl_vector_get(Cox, 0),gsl_vector_get(aox, 0))/pow(gsl_vector_get(Cred, 0),gsl_vector_get(ared, 0)));
    printf("\tComputed/Expected=%.6e/%.6e\n", computed, expected);
    equal = assert_equal(computed, expected, 2);

    gsl_vector_free(Cox);
    gsl_vector_free(Cred);
    gsl_vector_free(aox);
    gsl_vector_free(ared);
    if (!equal)
    {
        return EXIT_FAILURE;
    }


    return EXIT_SUCCESS;
}
