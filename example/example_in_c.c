#include <stdio.h>
#include <stdlib.h>
#include "ecx.h"


int main(void){

    int errstat, i;
    double w[3] = {1.0, 1.0, 1.0};
    double p[3] = {100.00, 0.0, 0.0};
    ecx_cdouble z[3] = {ecx_cbuild(0.0,0.0), ecx_cbuild(0.0, 0.0), ecx_cbuild(0.0, 0.0)};
    char *errmsg;

    ecx_eis_z(p, w, z, 'R', 3, 3, &errstat, &errmsg);
    
    for(i=0; i<3;i++){
        printf("%f %f \n", creal(z[i]), cimag(z[i]));
    }
    printf("%d %s\n", errstat, errmsg); 
    return EXIT_SUCCESS;
}
