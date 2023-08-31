#include <stdio.h>
#include <stdlib.h>
#include "ecx.h"


int main(void){

    int errstat;
    double w = 1.0;
    double r = 100.00;
    ecx_cdouble z = ecx_cbuild(0.0,0.0);

    ecx_eis_capi_z(&r, &w, &z, "R", 1, 1, &errstat);

    printf("%f I%f \n", creal(z), cimag(z));
    
    return EXIT_SUCCESS;
}