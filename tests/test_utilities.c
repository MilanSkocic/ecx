
/** 
 * @file test_utilites.c
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

int main(int argc, char **argv)
{

    double expected;
    double computed;
    int equal;
    double value;

    printf("\n");
    printf("***** TESTING ROUNDN *****");
    printf("\n");

    value = 100.239;
    equal = 0;
    computed = roundn(value, 2);
    expected = 100.238;
    printf("\tComputed/Expected=%.3f/%.3f\n", computed, expected);
    equal = asserEqual(computed, expected, 2);
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
    equal = asserEqual(computed * 1e2, expected * 1e2, 2);
    if (!equal)
    {
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
