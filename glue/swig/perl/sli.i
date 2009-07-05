/* -*- C -*- */

/* swig -perl5 -makedefault -module Heccer heccer.i */
/* gcc -c heccer_wrap.c `perl -MExtUtils::Embed -e ccopts`  */
/* gcc -shared heccer_wrap.o -L. -lheccer -o heccer.so */

%module SwiggableSLI

%{
#include "src/config.h"
%}

%inline %{

/* void piC2m_set(struct Intermediary *pim, int *piC2m) */
/* { */
/*     pim->piC2m = piC2m; */
/* } */

/// integer array handling

//t use array generics, see carray.i

int *int_array(int size)
{
    return (int *) malloc(sizeof(int) * size);
}
void int_destroy(int *a)
{
    free(a);
}
void int_set(int *a, int i, int val)
{
    a[i] = val;
}
int int_get(int *a, int i)
{
    return a[i];
}

/// double array handling

//t use array generics, see carray.i

double *double_array(int size)
{
    return (double *) malloc(sizeof(double) * size);
}
void double_destroy(double *a)
{
    free(a);
}
void double_set(double *a, int i, double val)
{
    a[i] = val;
}
double double_get(double *a, int i)
{
    return a[i];
}

%}

%include "src/config.h"

