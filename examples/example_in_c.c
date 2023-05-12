#include <stdio.h>
#include <stdlib.h>
#include "ecx_eis_capi.h"


int main(void){

    double w = 1.0;
    double r = 100.00;
    size_t n = 1;
    ecx_cdouble z = ecx_cbuild(0.0,0.0);

    ecx_capi_zr(&w, r, n, &z);

    printf("%f I%f \n", creal(z), cimag(z));
    
    return EXIT_SUCCESS;
}