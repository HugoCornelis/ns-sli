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


static int RegisterHeccerName(char *pcName);


//------------------------------------------------------------------
/*!
 *  \fn int AttemptHeccerName(char *pcName)
 *
 *  \return -1 on error, 1 on success, 0 for no operation.
 *
 *  Attempt to register pcName as a heccer name.  If any of the
 *  existing heccer names is a prefix of pcName, the attempt is a
 *  successful no-operation.
 */

//------------------------------------------------------------------
int AttemptHeccerName(char *pcName)
{
    struct neurospaces_integrator *pnsintegrator = getNsintegrator();

    //i
    //i first check to see if a heccer object with the same name exists.
    //i if so we don't register the name and exit.
    //i
    int i;
    char **ppcHeccerNames = pnsintegrator->ppcHeccerNames;
    int iHeccerNames = pnsintegrator->iHeccerNames;

    for (i = 0; i < iHeccerNames; i++)
    {
    
	if (!strncmp(pcName, ppcHeccerNames[i], strlen(ppcHeccerNames[i])))
	    return 0;

    }

    return(RegisterHeccerName(pcName));
}


//------------------------------------------------------------------
/*!
 *  \fn int RegisterHeccerName(char *pcName)
 *
 *  \return -1 on error, 1 on success, 0 for no operation.
 *
 *  Heccer names is an array of names to be translated into heccer
 *  objects.  This translation occurs during a RESET.
 */

//------------------------------------------------------------------
static int RegisterHeccerName(char *pcName)
{

  if(!pcName)
    return -1;

  struct neurospaces_integrator *pnsintegrator = getNsintegrator();

  if(!pnsintegrator)
      return -1;


  //- register the name of the heccer object

/*   if (pnsintegrator->iHeccerNames == 0 */
/*       && strcmp(pnsintegrator->ppcHeccerNames[pnsintegrator->iHeccerNames], HARDCODED_ROOT)) */
/*   { */
/*       pnsintegrator->ppcHeccerNames[pnsintegrator->iHeccerNames] =  */
/* 	  strdup(pcName); */
/*   } */
/*   else */
  {
      pnsintegrator->ppcHeccerNames[pnsintegrator->iHeccerNames++] = 
	  strdup(pcName);
  }

  return 1;
  

}


//------------------------------------------------------------------
/*!
 *  \fn int TranslateHeccerNames()
 *
 *  \return success of operation
 *  \param pnsintegrator G2 - G3 integrator element.
 *  \sa neurospaces_integrator
 *
 *  Translate heccer names to heccer objects, normally called during a
 *  RESET.
 *
 */
//------------------------------------------------------------------
int TranslateHeccerNames(struct neurospaces_integrator *pnsintegrator)
{
    //- default result: ok

    int iResult = 1;

    //i
    //i First create the heccer objects based on the crude heccer name
    //i registry. 
    //i

    int i;
    char **ppcHeccerNames = pnsintegrator->ppcHeccerNames;
    int iHeccerNames = pnsintegrator->iHeccerNames;

    for( i = 0; i < iHeccerNames; i++ )
    {
	if (InitHeccerObject(ppcHeccerNames[i]) == -1)
	{
	    iResult = 0;
	}
    }

    //- return result

    return(iResult);
}


//------------------------------------------------------------------
/*!
 *  \fn struct Heccer *LookupHeccerObject(char* pcContext)
 *  \return struct Heccer * Heccer with the given name, NULL for failure.
 *  \param pcContext name of the Heccer to search.
 *  \sa neurospaces_integrator
 *
 *  Lookup a Heccer instace in the global Heccer array in
 *  pelnsintegrator.
 *
 * \note This function works with the heccer array, which is created
 * after a RESET.  So don't call this function before a RESET, but use
 * the function LookupHeccerName() instead.
 *
 */
//------------------------------------------------------------------

struct Heccer *LookupHeccerObject(char *pcContext)
{
    struct neurospaces_integrator *pnsintegrator = getNsintegrator();
    int i;

    for (i = 0; i < pnsintegrator->iHeccers; i++)
    {
	if (0 == strcmp(pcContext, pnsintegrator->ppheccer[i]->pcName))
	{
	    return(pnsintegrator->ppheccer[i]);
	}
    }

    return(NULL);
}


//------------------------------------------------------------------
/*!
 *  \fn int InitHeccerObject()
 *
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

  //! Mando: interesting comment, but why ?  Can you explain?  Is this
  //! related to hardcoded_neutral ?  If so we need to discuss this
  //! because this 'hidden' logic can hide bugs easily.

  struct PidinStack *ppist = getRootedContext(pcContext);
  struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

  if(!phsle)
  {
      fprintf(stdout,"Warning: No neutral rooted object named %s for heccer.\n",pcContext);
      return 0;
  }

  PidinStackFree(ppist);

  //i
  //i First check to see if a heccer of a certain name has been created
  //i already. if so exit, this is a secondary check to prevent any 
  //i low level heccers from being created twice.
  //i

  {
      struct Heccer *pheccer = LookupHeccerObject(pcContext);

      if (pheccer)
      {
	  fprintf(stdout,
		  "Warning: Heccer object %s exists, resetting it instead.\n.",
		  pheccer->pcName);

	  singleHeccerReset(pheccer);
	  return 0;
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

  // \todo add this heccer to the global list come up with a function
  // for adding later.

  // \todo add boundary checking here.

  pnsintegrator->ppheccer[pnsintegrator->iHeccers++] = 
    pheccer;
  

  return 1;

}



