#include "heccer/heccer.h"

#include "neurospaces_defs.h"
#include "neurospaces_ext.h"
#include "neurospaces_struct.h"
#include "nsintegrator.h"

#include <stdio.h>

extern struct neurospaces_integrator *pNeurospacesIntegrator;

/*******************************************
 * Function creates a new heccer object and
 * initializes it to the Id given in parameter idin.
 *
 *******************************************/
int HeccerCreate(char* pcContext){

  char *pcHeccer =  strdup(pcContext);

  if(!pcHeccer){
    fprintf(stderr,"Error allocating pcHeccer (%s)\n",pcContext);
    return -1;
  }

  struct Heccer *pheccer = HeccerNew(pcHeccer,NULL,NULL,NULL);

  if(!pheccer){
    fprintf(stderr,"Error allocating Heccer for Context %s\n",pcContext);
    return -1;
  }

  struct Neurospaces *pneuro = 
     pNeurospacesIntegrator->pelNeurospaces->pneuro;

  HeccerConstruct(pheccer,(void *)pneuro,pcContext);

  HeccerCompileP1(pheccer);
  HeccerCompileP2(pheccer);
  HeccerCompileP3(pheccer);

  HeccerInitiate(pheccer);

  //t
  //t add this heccer to the global list
  //t come up with a function for adding later
  //t 
  pNeurospacesIntegrator->ppHeccer[pNeurospacesIntegrator->iHeccers++] = pheccer;
  
  return 1;

}



