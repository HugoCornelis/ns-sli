/************************************************
 *
 * 
 *
 ************************************************/
#include "neurospaces_ext.h"
#include "heccer/heccer.h"


#ifndef NSINTEGRATOR_H
#define NSINTEGRATOR_H



#define MAX_HECCERS 100

/*************************************************
 *  A single data structure encapulates all relevant
 *  data members for proper integration with
 *  neurospaces.
 ************************************************/

struct neurospaces_integrator{




  struct neurospaces_type *pelNeurospaces;




  struct Heccer *pheccer;




  /*********************************
   * The number of Heccer instances
   *
   ********************************/
  int iHeccers;

  
};









int NSGenesisInitialize();

#endif NSINTEGRATOR_H
