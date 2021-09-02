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
double get_kTe(double temperature){

    double kTe;
    
    kTe = kB * (temperature+T_K) / qe;
    return kTe;
}

/**
 * @brief Round off a value with n digits
 * @param x Value to be rounded
 * @param n Number of digits
 * @return y Rounded value.
 */
double roundn(double x, int n){

    double y;

  y = floor(log10(fabs(x)));

  //return round(x * pow(10, -y+n)) * pow(10, y-n);
    return x;
}
