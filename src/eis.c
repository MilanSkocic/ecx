/** 
 * @file eis.c
 *
 * @brief EIS equations.
 *
 * @details Complex impedance for:
 *  - resistance
 *  - capacitance
 *  - inductance
 *  - constant phase element
 *  - semi-infinite warburg
 *  - finite length warburg
 *  - finite space warburg 
 *  - Gerisher
 * 
 * Each element has a scalar form and a vectorized form using GSL vectors.
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
 *
 *  Author: Milan Skocic <milan.skocic@gmail.com>
 * 
 * @example example_eis.c
 * @details How to use resistance(), capacitance(), inductance()
 * cpe(), warburg(), finite_length_warburg(), finite_space_warburg()
 */

#include "electrox.h"


/**
 * @brief Compute resistance impedance
 * @details \f$ Z = R \forall \omega \f$
 * @param r Resistance in Ohms.
 * @param w Angular frequency in rad.s^-1.
 * @return Z Complex impedance in Ohms.
 */
double complex resistance(double r, double w)
{
    return (double complex)r;
}

/**
 * @brief Compute resistance impedance in vectorized form. 
 * @details \f$ Z = p_0 \forall \omega \f$
 * @param[in] p Pointer to the resistance in Ohms.
 * @param[in] w Pointer to th angular frequencies in rad.s^-1.
 * @param[out] Z Pointer to the complex impedance in Ohms.
 */
void gsl_resistance(gsl_vector *p, gsl_vector *w, gsl_vector_complex *Z)
{

    size_t i;

    double complex z;
    gsl_complex _z;
    double wi;
    double r = gsl_vector_get(p, 0);

    gsl_vector_complex_set_all(Z, gsl_complex_rect(r, 0));
}

/**
 * @brief Compute capacitance impedance
 * @details \f$ Z = \frac{1}{j C \omega} \f$
 * @param c Capacitance in F.
 * @param w Angular frequency in rad.s^-1.
 * @return Z Complex impedance in Ohms.
 */
double complex capacitance(double c, double w)
{
    return 1.0 / (I * c * w);
}

/**
 * @brief Compute capacitance impedance in vectorized form.
 * @details \f$ Z = \frac{1}{j p_0 \omega} \f$
 * @param[in] p Pointer to the capacitance in F.
 * @param[in] w Pointer to the angular frequency in rad.s^-1.
 * @param[out] Z Pointer to the complex impedance in Ohms.
 */
void gsl_capacitance(gsl_vector *p, gsl_vector *w, gsl_vector_complex *Z)
{

    size_t i;

    double complex z;
    gsl_complex _z;
    double wi;
    double c = gsl_vector_get(p, 0);

    for (i = 0; i < w->size; i++)
    {
        wi = gsl_vector_get(w, i);
        z = capacitance(c, wi);
        _z = gsl_complex_rect(creal(z), cimag(z));
        gsl_vector_complex_set(Z, i, _z);
    }
}

/**
 * @brief Compute inductance impedance
 * @details \f$ Z = j L \omega \f$
 * @param l Capacitance in H.
 * @param w Angular frequency in rad.s^-1.
 * @return Z Complex impedance in Ohms.
 */
double complex inductance(double l, double w)
{
    return I * l * w;
}

/**
 * @brief Compute inductance impedance in vectorized form.
 * @details \f$ Z = j p_0 \omega \f$
 * @param[in] p Pointer to the inductance in H.
 * @param[in] w Pointer to the angular frequency in rad.s^-1.
 * @param[out] Z Pointer to the Complex impedance in Ohms.
 */
void gsl_inductance(gsl_vector *p, gsl_vector *w, gsl_vector_complex *Z)
{

    size_t i;

    double complex z;
    gsl_complex _z;
    double wi;
    double l = gsl_vector_get(p, 0);

    for (i = 0; i < w->size; i++)
    {
        wi = gsl_vector_get(w, i);
        z = inductance(l, wi);
        _z = gsl_complex_rect(creal(z), cimag(z));
        gsl_vector_complex_set(Z, i, _z);
    }
}

/**
 * @brief Compute CPE impedance
 * @details \f$ Z = \frac{1}{Q(j w \omega)^a} \f$
 * @param Q CPE parameter in S.s^-a.
 * @param a CPE exponent.
 * @param w Angular frequency in rad.s^-1.
 * @return Z Complex impedance in Ohms.
 */
double complex cpe(double Q, double a, double w)
{
    return 1.0 / (Q * pow(I * w, a));
}

/**
 * @brief Compute CPE impedance in vectorized.
 * @details \f$ Z = \frac{1}{p_0(j \omega)^{p_1}} \f$
 * @param[in] p Pointer to the CPE parameters.
 * @param[in] w Angular frequency in rad.s^-1.
 * @param[out] Z Complex impedance in Ohms.
 */
void gsl_cpe(gsl_vector *p, gsl_vector *w, gsl_vector_complex *Z)
{
    size_t i;
    double complex z;
    gsl_complex _z;
    double wi;
    double Q = gsl_vector_get(p, 0);
    double a = gsl_vector_get(p, 1);

    for (i = 0; i < w->size; i++)
    {
        wi = gsl_vector_get(w, i);
        z = cpe(Q, a, wi);
        _z = gsl_complex_rect(creal(z), cimag(z));
        gsl_vector_complex_set(Z, i, _z);
    }
}

/**
 * @brief Compute semi-infinite warburg impedance
 * @details \f$ Z = \frac{\sigma}{\sqrt{\omega}} \cdot (1-j) \f$
 * @param sigma Pseudo-Resistance in Ohms.s^(1/2).
 * @param w Angular frequency in rad.s^-1.
 * @return Z Complex impedance in Ohms.
 */
double complex warburg(double sigma, double w)
{
    return sigma / sqrt(w) * (1 - I);
}

/**
 * @brief Compute semi-infinite warburg impedance in vectorized form.
 * @details \f$ Z = \frac{p_0}{\sqrt{\omega}} \cdot (1-j) \f$
 * @param[in] p Pointer to the pseudo-Resistance in Ohms.s^(1/2).
 * @param[in] w Pointer to the angular frequency in rad.s^-1.
 * @param[out] Z Pointer to the complex impedance in Ohms.
 */
void gsl_warburg(gsl_vector *p, gsl_vector *w, gsl_vector_complex *Z)
{
    size_t i;
    double wi, sigma;
    gsl_complex _z;
    double complex z;

    sigma = gsl_vector_get(p, 0);

    for (i = 0; i < w->size; i++)
    {
        wi = gsl_vector_get(w, i);
        z = warburg(sigma, wi);
        _z = gsl_complex_rect(creal(z), cimag(z));
        gsl_vector_complex_set(Z, i, _z);
    }
}

/**
 * @brief Compute finite length warburg impedance
 * @details \f$ Z = \frac{r}{\sqrt{j \tau \omega}} \cdot \tanh \sqrt{j \tau
 * \omega} \f$
 * @param r Resistance in Ohms.
 * @param tau Characteristic time in s.
 * @param w Angular frequency in rad.s^-1.
 * @return Z Complex impedance in Ohms.
 */
double complex finite_length_warburg(double r, double tau, double w)
{
    return r * ctanh(csqrt(I * tau * w)) / csqrt(I * tau * w);
}

/**
 * @brief Compute finite length warburg impedance in vectorized form.
 * @details \f$ Z = \frac{p_0}{\sqrt{j p_1 \omega}} \cdot \tanh \sqrt{j p_1
 * \omega} \f$
 * @param[in] p Pointer to the parameters in Ohms.
 * @param[in] w Pointer to the angular frequency in rad.s^-1.
 * @param[out] Z Pointer to the complex impedance in Ohms.
 */
void gsl_finite_length_warburg(gsl_vector *p, gsl_vector *w, gsl_vector_complex *Z)
{
    size_t i;
    double complex z;
    gsl_complex _z;
    double wi;
    double R = gsl_vector_get(p, 0);
    double tau = gsl_vector_get(p, 1);
    double n = gsl_vector_get(p, 2);

    for (i = 0; i < w->size; i++)
    {

        wi = gsl_vector_get(w, i);
        z = finite_length_warburg(R, tau, wi);
        _z = gsl_complex_rect(creal(z), cimag(z));
        gsl_vector_complex_set(Z, i, _z);
    }
}
/**
 * @brief Compute finite space warburg impedance
 * @details \f$ Z = \frac{r}{\sqrt{j \tau \omega}} \cdot \coth \sqrt{j \tau
 * \omega} \f$
 * @param r Resistance in Ohms.
 * @param tau Characteristic time in s.
 * @param w Angular frequency in rad.s^-1.
 * @return Z Complex impedance in Ohms.
 */
double complex finite_space_warburg(double r, double tau, double w)
{
    return r / (ctanh(csqrt(I * tau * w)) * csqrt(I * tau * w));
}

/**
 * @brief Compute finite space warburg impedance in vectorized form.
 * @details \f$ Z = \frac{p_0}{\sqrt{j p_1 \omega}} \cdot \coth \sqrt{j p_1
 * \omega} \f$
 * @param[in] p Pointer to the parameters in Ohms.
 * @param[in] w Pointer to the angular frequency in rad.s^-1.
 * @param[out] Z Pointer to the complex impedance in Ohms.
 */
void gsl_finite_space_warburg(gsl_vector *p, gsl_vector *w, gsl_vector_complex *Z)
{
    size_t i;
    double complex z;
    gsl_complex _z;
    double wi;
    double R = gsl_vector_get(p, 0);
    double tau = gsl_vector_get(p, 1);
    double n = gsl_vector_get(p, 2);

    for (i = 0; i < w->size; i++)
    {

        wi = gsl_vector_get(w, i);
        z = finite_space_warburg(R, tau, wi);
        _z = gsl_complex_rect(creal(z), cimag(z));
        gsl_vector_complex_set(Z, i, _z);
    }
}

/**
 * @brief Compute the complex impedance of the Gerisher element.
 * @details \f$ Z = \frac{G}{\sqrt{K+j\omega}}\f$
 * @param G Pseudo-Resistance in Ohms.s^(1/2).
 * @param K Offset in rad.s^-1.
 * @param w Angular frequency in rad.s^-1.
 * @return Z Complex impedance in Ohms. 
 */
double complex gerisher(double G, double K, double w){
    return G / csqrt(K+I*w);
}

/**
 * @brief Compute the complex impedance of the Gerisher element in vectorized form.
 * @details \f$ Z = \frac{p_0}{\sqrt{p_1+j\omega}}\f$
 * @param[in] p Pointer to the pseudo-resistance in Ohms.s^-1.
 * @param[in] w Pointer to the angular frequency in rad.s^-1.
 * @param[out] Z Pointer to the complex impedance in Ohms.
 */
void gsl_gerisher(gsl_vector *p, gsl_vector *w, gsl_vector_complex *Z){

    size_t i;
    double complex z;
    gsl_complex _z;
    double wi;
    double G = gsl_vector_get(p, 0);
    double K = gsl_vector_get(p, 1);

    for (i = 0; i < w->size; i++)
    {
        wi = gsl_vector_get(w, i);
        z = gerisher(G, K, wi);
        _z = gsl_complex_rect(creal(z), cimag(z));
        gsl_vector_complex_set(Z, i, _z);
    }

}

/**
 * @brief  EIS Element
 * @details Constructor of an EisElement.
 * @param name Pointer to the name
 * @param type Pointer to the type
 * @return EisElement Pointer to object EisElement
 */
EisElement *EisElement__new__(char *name, ElementType type)
{
    /* Memory allocation */
    EisElement *self = (EisElement *)malloc(sizeof(EisElement));
    self->__del__ = &EisElement__del__;
    self->__init__ = &EisElement__init__;
    self->__init__(self, name, type);
    return self;
}

/**
 * @brief Initialize an EIS element
 * @details Initialize an EIS element
 * @param self Pointer to an object EisElement
 * @param name Pointer to the name
 * @param type Pointer to the type
 * @return None
 */
void EisElement__init__(EisElement *self, char *name, ElementType type)
{
    self->name = (char *)malloc(sizeof(char) * (strlen(name) + 1));
    strcpy(self->name, name);
    self->type = type;

    switch (self->type)
    {
    case R:
        self->Z = &gsl_resistance;
        self->p = gsl_vector_alloc(1);
        break;
    case C:
        self->Z = &gsl_capacitance;
        self->p = gsl_vector_alloc(1);
        break;
    case Q:
        self->Z = &gsl_cpe;
        self->p = gsl_vector_alloc(2);
        break;
    case L:
        self->Z = &gsl_inductance;
        self->p = gsl_vector_alloc(1);
        break;
    case W:
        self->Z = &gsl_warburg;
        self->p = gsl_vector_alloc(1);
        break;
    case Wd:
    case Ws:
    case O:
        self->Z = &gsl_finite_length_warburg;
        self->p = gsl_vector_alloc(3);

        break;
    case Wm:
    case Wo:
    case T:
        self->Z = &gsl_finite_space_warburg;
        self->p = gsl_vector_alloc(3);
        break;
    default:
        self->Z = NULL;
        self->p = NULL;
        break;
    }
}

void EisElement__del__(EisElement *self)
{
    free(self->name);
    gsl_vector_free(self->p);
    free(self);
}

/**
 * @brief EisCircuit
 * @details Constructor of an EisCircuit
 * @param name Pointer to the name
 * @param repr Pointer to the representation
 */
EisCircuit *EisCircuit__new__(char *name, char *repr)
{
    EisCircuit *c = (EisCircuit *)malloc(sizeof(EisCircuit));
    EisCircuit__init__(c, name, repr);
    return c;
}

/**
 * @brief Initialize an EIS circuit
 * @details Initialize an EIS circuit
 * @param self Pointer to an object EisCircuit
 * @param name Pointer to the name
 * @param type Pointer to the string representation
 * @return None
 */
void EisCircuit__init__(EisCircuit *self, char *name, char *repr)
{
    int i;
    int N = 3;
    ElementType type = R;
    printf("INIT CIRCUIT\n");
    char *names[3] = {"E1", "E2", "E3"};

    /* Process repr to get the number of elements 
     * Populate with EisElements
     */
    self->elements = (EisElement **)malloc(N * sizeof(EisElement *));
    for (i = 0; i < N; i++)
    {
        self->elements[i] = EisElement__new__(names[i], type);
    }
    self->name = (char *)malloc(sizeof(char) * (strlen(name) + 1));
    strcpy(self->name, name);
    self->repr = (char *)malloc(sizeof(char) * (strlen(repr) + 1));
    strcpy(self->repr, repr);
}
