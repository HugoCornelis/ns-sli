//------------------------------------------------------------------
/*!
 *  \file heccercreate.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for creating a Heccer 
 *  instance directly with the Heccer API.
*/
//-------------------------------------------------------------------
#include "neurospaces_defs.h"
#include "nsintegrator.h"

#include <stdio.h>



//------------------------------------------------------------------
/*
 *  Externals in sim_clock.c
 */
extern short			nactive_clocks;
extern short			clock_set[NCLOCKS];
extern short			clock_active[NCLOCKS];
extern double			clock_value[NCLOCKS];
//------------------------------------------------------------------





//------------------------------------------------------------------
/*!
 *  \fn int HeccerCreate(char* pcContext)
 *  \return -1 on error, 1 on success.
 *  \param pcContext A char array holding the name for the Heccer to create.
 *  \sa neurospaces_integrator
 *
 *  Creates a Heccer instace and stores is in the global Heccer
 *  array in pelnsintegrator.
 *
 */
//------------------------------------------------------------------
int HeccerCreate(char* pcContext){


  struct Heccer *pheccer = HeccerNew(pcContext,NULL,NULL,NULL);

  if(!pheccer){
    fprintf(stderr,"Error allocating Heccer for Context %s\n",pcContext);
    return -1;
  }


  pheccer->dStep = clock_value[0];
  
 
  struct nsintegrator_type *pelnsintegrator
    = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  struct neurospaces_integrator *pnsintegrator
    = pelnsintegrator->pnsintegrator;


  struct Neurospaces *pneuro = 
     pnsintegrator->pelNeurospaces->pneuro;


  //-
  //- Here we copy over the heccer options parsed from
  //- a setup if present.
  //-
  pheccer->ho = pnsintegrator->pheccerOptions->ho;

  
  HeccerConstruct(pheccer,(void *)pneuro,pcContext);

  HeccerCompileP1(pheccer);
  HeccerCompileP2(pheccer);
  HeccerCompileP3(pheccer);

  HeccerInitiate(pheccer);

  //t
  //t add this heccer to the global list
  //t come up with a function for adding later
  //t 
  pnsintegrator->ppheccer[pnsintegrator->iHeccers++] = 
    pheccer;
  
  return 1;

}



