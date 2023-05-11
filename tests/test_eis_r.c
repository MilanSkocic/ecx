#include "test_common.h"


int main(void){

    double R = 100.0;
    double w = 1.0;
    ecx_cdouble z;
    double reference;
    double value;
    double diff;
    
    printf("***** SCALAR INPUT *****\n");
    ecx_capi_zr(&w, R, 1, &z);
    reference = R;
    value = creal(z);
    diff = roundn(value - reference, 6);
    printf("z.real: %+10.6f/%+10.6f/%+10.6f\n", value, reference, diff);
    if(diff != 0.0){
        return EXIT_FAILURE;
    } 
    reference = 0.0;
    value = cimag(z);
    diff = roundn(value - reference, 6);
    printf("z.imag: %+10.6f/%+10.6f/%+10.6f\n", value, reference, diff);
    if(diff != 0.0){
        return EXIT_FAILURE;
    } 
    

    return EXIT_SUCCESS;

}
