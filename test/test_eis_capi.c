#include <stdio.h>
#include <math.h>
#include "ecx.h"
#include "common.h"

int test_zr(void){

    int errstat;
    double w[1] = {1.0};
    double p[3] = {100.0, 100.0, 100.0};
    ecx_cdouble z[1];
    ecx_cdouble value;
    ecx_cdouble expected = ecx_cbuild(100.0, 0.0);
    ecx_cdouble diff;
    printf("    %s", "Z_R...");
    ecx_eis_capi_z(p, w, z, 'R', 3, 3, &errstat);
    value = z[0];
    diff = value - expected;
    if((!assertEqual(creal(diff), 0.0, 16)) | (!assertEqual(cimag(diff), 0.0, 16))){
        printf("%s %d\n", "failed");
        printf("    %+23.16e  %+23.16e\n", creal(value), cimag(value));
        printf("    %+23.16e  %+23.16e\n", creal(expected), cimag(expected));
        printf("    %+23.16e  %+23.16e\n", creal(diff), cimag(diff));
    }
        printf("%s\n", "OK");

}

int test_zc(void){

    int errstat;
    double w[1] = {0.01};
    double p[3] = {100.0, 100.0, 100.0};
    ecx_cdouble z[1];
    ecx_cdouble value;
    ecx_cdouble expected = ecx_cbuild(0.0, -1.0);
    ecx_cdouble diff;
    printf("    %s", "Z_C...");
    ecx_eis_capi_z(p, w, z, 'C', 3, 3, &errstat);
    value = z[0];
    diff = value - expected;
    if((!assertEqual(creal(diff), 0.0, 16)) | (!assertEqual(cimag(diff), 0.0, 16))){
        printf("%s\n", "failed");
        printf("    %+23.16e  %+23.16e\n", creal(value), cimag(value));
        printf("    %+23.16e  %+23.16e\n", creal(expected), cimag(expected));
        printf("    %+23.16e  %+23.16e\n", creal(diff), cimag(diff));
    }
        printf("%s\n", "OK");

}

int test_zl(void){

    int errstat;
    double w[1] = {0.01};
    double p[3] = {100.0, 100.0, 100.0};
    ecx_cdouble z[1];
    ecx_cdouble value;
    ecx_cdouble expected = ecx_cbuild(0.0, 1.0);
    ecx_cdouble diff;
    printf("    %s", "Z_L...");
    ecx_eis_capi_z(p, w, z, 'L', 3, 3, &errstat);
    value = z[0];
    diff = value - expected;
    if((!assertEqual(creal(diff), 0.0, 16)) | (!assertEqual(cimag(diff), 0.0, 16))){
        printf("%s\n", "failed");
        printf("    %+23.16e  %+23.16e\n", creal(value), cimag(value));
        printf("    %+23.16e  %+23.16e\n", creal(expected), cimag(expected));
        printf("    %+23.16e  %+23.16e\n", creal(diff), cimag(diff));
    }
        printf("%s\n", "OK");

}

int main(void){


    printf("%s\n", "***** TESTING C API CODE FOR EIS *****");

    test_zr();
    test_zc();
    test_zl();

}