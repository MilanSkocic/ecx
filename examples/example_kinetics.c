/** 
 * @file example_kinetics.c
 *
 * @brief Example of kinetics equation.
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
#include <argp.h>
#include "electrox.h"

const char *argp_program_version = "Example of using electrox";
const char *argp_program_bug_address = "<bug-gnu-utils@gnu.org>";

static char doc[] = "Example #1 -- a program with options and arguments using argp";
static char args_doc[] = "U1 U2 ... Un";
static struct argp_option options[] = {
    {"verbose", 'v', 0, 0, "Produce verbose output"},
    {"quiet", 'q', 0, 0, "Don't produce any output"},
    {"silent", 's', 0, OPTION_ALIAS},
    {"output", 'o', "FILE", 0, "Output to FILE instead of standard output"},
    {0}};

struct arguments
{
  int argc;
  double *U;
  int silent, verbose;
  char *output_file;
};

static error_t parse_opt(int key, char *arg, struct argp_state *state)
{
  struct arguments *arguments = state->input;

  switch (key)
  {
  case 'q':
  case 's':
    arguments->silent = 1;
    break;
  case 'v':
    arguments->verbose = 1;
    break;
  case 'o':
    arguments->output_file = arg;
    break;

  case ARGP_KEY_NO_ARGS:
    argp_usage(state);
    break;

  case ARGP_KEY_ARG:
    /* increase U size */
    arguments->U = (double *)realloc(arguments->U, (arguments->argc + 1) * sizeof(double));
    /* Add new value */
    arguments->U[arguments->argc] = strtod(arg, NULL);
    /* increase counter */
    arguments->argc = arguments->argc + 1;

    break;

  default:
    return ARGP_ERR_UNKNOWN;
  }
  return 0;
}

/* Our argp parser. */
static struct argp argp = {options, parse_opt, args_doc, doc};

int main(int argc, char **argv)
{
  int i;
  double OCV = 0.0;
  double j0 = 1e-6;
  double jdla = 1e6;
  double jdlc = 1e6;
  double aa = 0.5;
  double ac = 0.5;
  double za = 1;
  double zc = 1;
  double S = 1.0;
  double T = 25.0;

  double current;

  struct arguments arguments;

  arguments.silent = 0;
  arguments.verbose = 0;
  arguments.output_file = "-";
  arguments.argc = 0;
  arguments.U = NULL;

  argp_parse(&argp, argc, argv, 0, 0, &arguments);

  if (arguments.verbose)
  {
    printf("verbose");
  }

  for (i = 0; i < arguments.argc; i++)
  {
    current = bv(OCV, arguments.U[i], j0, jdla, jdlc, aa, ac, za, zc, S, T);
    printf("U=%f - %.4eA\n", arguments.U[i], current);
    current = sbv(OCV, arguments.U[i], j0, aa, ac, za, zc, S, T);
  }

  free(arguments.U);

  exit(0);
}
