

#ifndef NEUROSPACES_STRUCT_H
#define NEUROSPACES_STRUCT_H


#include "../sim/struct_defs.h"

#define MAX_NUM_OF_PROJECTIONS		20

/* neurospaces model description */

struct neurospaces_type
{
    ELEMENT_TYPE

    //m globals from reading description file

    struct Neurospaces *pneuro;


    // pointer to global NS integrator
  //    struct neurospaces_integrator * pgNeurospacesIntegrator;

    //m should projection query be caching ?

    int bCaching;

    //m projections to be queried during reset

//    struct ProjectionQuery *ppq;

//    struct symtab_Projection * ppproj[MAX_NUM_OF_PROJECTIONS];

    struct PidinStack * pppistProjections[MAX_NUM_OF_PROJECTIONS];

    int iProjections;
  

};


#endif


