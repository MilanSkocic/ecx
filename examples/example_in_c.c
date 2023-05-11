#include <stdio.h>
#include <stdlib.h>
#include "ecx.h"


int main(void){

    double w = 1.0;
    double r = 100.00;
    size_t n = 1;
    size_t n1 = 3;
    size_t i;
    ecx_cdouble z = ecx_cbuild(0.0,0.0);

    double *w1 = (double *)malloc(sizeof(double)*n1);
    ecx_cdouble *z1 = (ecx_cdouble *)malloc(sizeof(ecx_cdouble)*n1);

    for(i=0; i<n1;i++){
        w1[i] = i;
        z1[i] = ecx_cbuild(i, i);
        printf("%f I%f \n", creal(z1[i]), cimag(z1[i]));
    }

    ecx_capi_zr(&w, r, n, &z);

    printf("%f I%f \n", creal(z), cimag(z));
    printf("%f I%f \n", creal(z), cimag(z));
    
    ecx_capi_zr(w1, r, n1, z1);


    for(i=0; i<n1;i++){
        printf("%f I%f \n", creal(z1[i]), cimag(z1[i]));
    }

    return EXIT_SUCCESS;
}