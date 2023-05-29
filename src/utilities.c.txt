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
 * @param[in] temperature Temperature in °C
 * @param[in] mV Flag for indicating if the results is in mV.
 * @return kT/e in V or mV.
 */
double get_kTe(double temperature, int mV)
{

  double kTe;
  kTe = kB * (temperature + T_K) / qe;
  if (mV)
  {
    kTe *= 1000.0;
  }
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
  double fac = pow(10, n);

  rounded_x = round(x * fac) / fac;

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
 * @brief Round errors.
 * @details The rounded value is computed as the ceil of the value in scientific
 * notation without the exponent.
 * @param[in] x Error value to be rounded.
 * @return Rounded error value. 
 */
double round_error(double x)
{
  double logx;
  double fac;
  double rounded_error;

  logx = floor(log10(x));
  fac = pow(10, -logx);

  rounded_error = ceil(x * fac) / fac;

  return rounded_error;
}

/**
 * @brief Round x according to its error dx.
 * @details The difference in precision of x and dx is used to round properly.
 * @param[in] x Value to be rounded.
 * @param[in] dx Associated error with x.
 * @return Rounded value.
 */
double round_value(double x, double dx)
{

  double logx, logdx, d, rounded_x;

  logdx = floor(log10(dx));
  logx = floor(log10(x));

  d = logx - logdx;

  rounded_x = round_significant(x, d);

  return rounded_x;
}

/**
 * @brief Test if a and b are equals to n digits.
 * @param[in] a Number 1
 * @param[in] b Number 2
 * @param[in] n digits
 * @return 0=False or 1=True
 */
int assert_equal(double a, double b, int n)
{

  double d = a - b;

  if (roundn(d, n) != 0.0)
  {
    printf("The difference was of %.16e", d);
    return 0;
  }

  return 1;
}