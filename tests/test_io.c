/** 
 * @file test_io.c
 *
 * @brief Tests I/O.
 *
 * @details Test I/O functions.
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
#include <errno.h>
#include <string.h>
#include "electrox.h"

int main(int argc, char **argv){

    errno = 0;

    char *fpath = "../tests/test_z.z";
    int verbose = 1;

    errno = read_z(fpath, verbose);

    if(errno){
        return  EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}