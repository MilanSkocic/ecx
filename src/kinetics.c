/** 
 * @file kinetics.c
 *
 * @brief Kinetics equation.
 *
 * @details Kinetics equations:
 *  - butler-volmer without mass transport
 *  - butler-volmer with mass transport
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
 * @brief Compute Butler Volmer equation.
 * @details details
 * @param[in] OCV Open Circuit Potential in Volts
 * @param[in] U Potential to compute in Volts
 * @param[in] j0 Exchange current density in A.cm-2
 * @param[in] jdla Anodic diffusion limiting current density in A.cm-2
 * @param[in] jdlc Cathodic diffusion limiting current density in A.cm-2
 * @param[in] aa Anodic transfer coefficient
 * @param[in] ac Cathodic transfer coefficient
 * @param[in] za Anodic number of exchanged electrons
 * @param[in] zc Cathodic number of exchanged electrons
 * @param[in] S Area in cm2
 * @param[in] T Temperature in °C
 * @return i Current in A.
 */
double bv(double OCV, double U, double j0, double jdla, double jdlc,
          double aa, double ac, double za, double zc,
          double S, double T){
          double kTe;
          double num;
          double denom;
          double i;

    kTe = kB * (T+T_K) / qe;
    num = j0 * (exp(aa*za*(U-OCV)/kTe) -  exp(-ac*zc*(U-OCV)/kTe));
    denom = 1 + j0/jdla*exp(aa*za*(U-OCV)/kTe) + j0/jdlc*exp(-ac*zc*(U-OCV)/kTe);
    
    i = S*num/denom;
    
    return i;

}

/**
 * @example example1.c
 */


