/**
 * \file utilities.c
 *
 * @brief Utilities
 *
 * @details Functions that are needed for computation.
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

#include "electrox.h"

/**
 * @brief Compute Butler Volmer equation
 * @param temperature Temperature in °C
 * @return kTe kT/e in Volts.
 */
double get_kTe(double temperature)
{

  double kTe;

  kTe = kB * (temperature + T_K) / qe;
  return kTe;
}

/**
 * @brief Round off a value with n digits
 * @param x Value to be rounded
 * @param n Number of digits
 * @return Rounded x.
 */
double roundn(double x, int n)
{

  double rounded_x;

  rounded_x = round(x * pow(10, n)) * pow(10, -n);

  return rounded_x;
}

/**
 * @brief Round x to n digits in scientific notation.
 * @param[in] x Number to be round
 * @param[in] n Number of digits for rounding.
 * @return Rounded x.
 */
double round_significant(double x, int n)
{

  double rounded_x;
  double logx;
  double fac;

  logx = floor(log10(x));
  fac = pow(10, -logx);

  rounded_x = roundn(x * fac, n) / fac;
  return rounded_x;
}

/**
 * @brief Test if a and b are equals to n digits.
 * @param[in] a Number 1
 * @param[in] b Number 2
 * @param[in] n digits
 * @return 0=False or 1=True
 */
int asserEqual(double a, double b, int n)
{

  double d = a - b;

  if (roundn(d, n) != 0.0)
  {
    printf("The difference was of %.16e", d);
    return 0;
  }

  return 1;
}
