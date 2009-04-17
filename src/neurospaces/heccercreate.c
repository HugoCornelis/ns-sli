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
 *  \fn int RegisterHeccerObject(char *pcName)
 */

//------------------------------------------------------------------
int RegisterHeccerObject(char *pcName)
{

  if(!pcName)
    return -1;

  struct neurospaces_integrator *pnsintegrator = getNsintegrator();

  if(!pnsintegrator)
    return -1;

  //i
  //i first check to see if a heccer object with the same name exists.
  //i if so we don't register the name and exit.
  //i
  int i;
  char **ppcHeccerNames = pnsintegrator->ppcHeccerNames;
  int iHeccerNames = pnsintegrator->iHeccerNames;

  for(i = 0; i < iHeccerNames; i++)
  {
    
    if(!strcmp(pcName,ppcHeccerNames[i]))
      return 0;

  }


  pnsintegrator->ppcHeccerNames[pnsintegrator->iHeccerNames++] = 
    strdup(pcName);

  return 1;
  

}




//------------------------------------------------------------------
/*!
 *  \fn int HeccerCreate(char* pcContext)
 *  \return -1 on error, 1 on success.
 *  \param pcContext A char array holding the name for the Heccer to create.
 *  \return -1 on error, 1 on success, 0 for no operation.
 *  \sa neurospaces_integrator
 *
 *  Creates a Heccer instace and stores is in the global Heccer
 *  array in pelnsintegrator.
 *
 */
//------------------------------------------------------------------
int InitHeccerObject(char* pcContext){



  struct neurospaces_integrator *pnsintegrator = getNsintegrator();


  //i
  //i First check for a matching neutral element in the model container
  //i before performing a reset. Without a check it can cause a seg fault
  //i or no output.

  struct symtab_HSolveListElement *phsle = NSLookupHSolveListElement(pcContext);

  if(!phsle)
  {
    //fprintf(stdout,"Warning: No neutral rooted object named %s for heccer.\n",pcContext);
    return 0;
  }



  //i
  //i First check to see if a heccer of a certain name has been created
  //i already. if so exit, this is a secondary check to prevent any 
  //i low level heccers from being created twice.
  //i
  if( pnsintegrator->iHeccers > 0 )
  {
    int i;
    int iHeccers = pnsintegrator->iHeccers;
    struct Heccer **ppheccer = pnsintegrator->ppheccer;

    for(i = 0; i < iHeccers; i++)
    {
      if(!strcmp(pcContext,ppheccer[i]->pcName))
      {
	fprintf(stdout,
		"Warning: Heccer object %s exists, resetting it instead.\n.",
		ppheccer[i]->pcName);

	singleHeccerReset(ppheccer[i]);
	return 0;
      }
    }
  }




  struct Heccer *pheccer = HeccerNew(pcContext,NULL,NULL,NULL);

  if(!pheccer){
    fprintf(stderr,"Error allocating Heccer for Context %s\n",pcContext);
    return -1;
  }


  pheccer->dStep = clock_value[0];
  
 


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



