

#ifndef HSOLVE_STRUCT_H
#define HSOLVE_STRUCT_H


#include "struct_defs.h"

#define MAX_NUM_OF_PROJECTIONS		20

/* hsolve model description */

struct hsolve_type
{

    ELEMENT_TYPE


    int chanmode;

    int comptmode;

    int calcmode;

    char * findsolvefield;

    char * path;
};


#endif


