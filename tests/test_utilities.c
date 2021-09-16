/** 
 * @file test_utilities.c
 *
 * @brief Tests Utilities.
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
 * @brief Main Test Suite
 */
int main(int argc, char **argv)
{

    double expected;
    double computed;
    int equal;
    double value, error;

    printf("\n");
    printf("***** TESTING kT/e *****");
    printf("\n");

    equal = 0;
    computed = roundn(get_kTe(25.0, 1), 1);
    expected = 25.7;
    printf("\tComputed/Expected=%.3f/%.3f\n", computed, expected);
    equal = assert_equal(computed, expected, 1);
    if (!equal)
    {
        return EXIT_FAILURE;
    }

    printf("\n");
    printf("***** TESTING ROUNDN *****");
    printf("\n");

    value = 100.239;
    equal = 0;
    computed = roundn(value, 2);
    expected = 100.240;
    printf("\tComputed/Expected=%.3f/%.3f\n", computed, expected);
    equal = assert_equal(computed, expected, 2);
    if (!equal)
    {
        return EXIT_FAILURE;
    }

    printf("\n");
    printf("***** TESTING ROUND_SIGNIFICANT *****");
    printf("\n");

    value = 1.034e-2;
    equal = 0;
    computed = round_significant(value, 2);
    expected = 1.03e-2;
    printf("\tComputed/Expected=%.3e/%.3e\n", computed, expected);
    equal = assert_equal(computed * 1e2, expected * 1e2, 2);
    if (!equal)
    {
        return EXIT_FAILURE;
    }
    value = 1.134e-2;
    equal = 0;
    computed = round_significant(value, 0);
    expected = 1.0e-2;
    printf("\tComputed/Expected=%.3e/%.3e\n", computed, expected);
    equal = assert_equal(computed * 1e2, expected * 1e2, 2);
    if (!equal)
    {
        return EXIT_FAILURE;
    }

    printf("\n");
    printf("***** TESTING ROUND ERROR *****");
    printf("\n");

    value = 1.034e-2;
    equal = 0;
    computed = round_error(value);
    expected = 2e-2;
    printf("\tComputed/Expected=%.3e/%.3e\n", computed, expected);
    equal = assert_equal(computed * 1e2, expected * 1e2, 2);
    if (!equal)
    {
        return EXIT_FAILURE;
    }

    printf("\n");
    printf("***** TESTING ROUND VALUE + ERROR *****");
    printf("\n");

    value = 1.034e-2;
    error = 2.3e-4;
    computed = round_value(value, error);
    expected = 1.03e-2;
    printf("\tComputed/Expected=%.3e/%.3e\n", computed, expected);
    equal = assert_equal(computed * 1e2, expected * 1e2, 2);
    if (!equal)
    {
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
