#include <stdio.h>
#include <math.h>
#include "ecx.h"


static double roundn(double x, int n){
    double fac;
    double rounded_x;
    fac = pow(10, n);
    rounded_x = round(x*fac)/fac;
    return rounded_x;
}

static int assertEqual(double x1, double x2, int n){
    int r;

    double fac;
    double ix1, ix2;

    fac = pow(10, n);
    ix1 = round(x1 * fac);
    ix2 = round(x2 * fac);

    r = ix1 == ix2;

    return r;
}

int test_zr(void){

    double w[1] = {1.0};
    double p[1] = {100.0};
    ecx_cdouble z[1];
    ecx_cdouble value;
    ecx_cdouble expected = ecx_cbuild(100.0, 0.0);
    ecx_cdouble diff;
    printf("    %s", "Z_R...");
    ecx_eis_capi_z('R', p, w, z, 1, 1);
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

int test_zc(void){

    double w[1] = {0.01};
    double p[1] = {100.0};
    ecx_cdouble z[1];
    ecx_cdouble value;
    ecx_cdouble expected = ecx_cbuild(0.0, -1.0);
    ecx_cdouble diff;
    printf("    %s", "Z_C...");
    ecx_eis_capi_z('C', p, w, z, 1, 1);
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

    double w[1] = {0.01};
    double p[1] = {100.0};
    ecx_cdouble z[1];
    ecx_cdouble value;
    ecx_cdouble expected = ecx_cbuild(0.0, 1.0);
    ecx_cdouble diff;
    printf("    %s", "Z_L...");
    ecx_eis_capi_z('L', p, w, z, 1, 1);
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