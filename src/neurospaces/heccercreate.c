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
 *  External in sim_clock.c
 */

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

    //- if this name is in the proto library

    if (strncmp(pcName, "/proto", strlen("/proto")) == 0)
    {
	//- this is assumed to be disabled, so return success

	return 0;
    }

    //- if a heccer object with the same name exists.

    int i;

    for (i = 0 ; i < pnsintegrator->iModelRegistrations ; i++)
    {
	if (!strncmp(pcName, pnsintegrator->psr[i].pcName, strlen(pnsintegrator->psr[i].pcName)))
	{
	    //- if so we don't register the name and exit with success.

	    return 0;
	}
    }

    return(RegisterHeccerName(pcName));
}


//------------------------------------------------------------------
/*!
 *  \fn int SetSolverOptions(char *pcName)
 *
 *  \return -1 on error, 1 on success, 0 for no operation.
 *
 *  Set options to use when creating this solver.
 */

//------------------------------------------------------------------
int SetSolverOptions(char *pcName, int iOptions)
{
    struct neurospaces_integrator *pnsintegrator = getNsintegrator();

    //i
    //i first check to see if a heccer object with the same name exists.
    //i if so we don't register the name and exit.
    //i

    int i;

    for (i = 0 ; i < pnsintegrator->iModelRegistrations ; i++)
    {
	if (strncmp(pcName, pnsintegrator->psr[i].pcName, strlen(pnsintegrator->psr[i].pcName)) == 0)
	{
	    break;
	}
    }

    if (i < pnsintegrator->iModelRegistrations)
    {
	pnsintegrator->psr[i].uSolver.si.iOptions |= iOptions;

	return 1;
    }
    else
    {
	return -1;
    }
}


//------------------------------------------------------------------
/*
*
*/
//------------------------------------------------------------------
int DisableHeccerName(char *pcName)
{
    struct neurospaces_integrator *pnsintegrator = getNsintegrator();

    //- make sure there is a registration for this entry

    AttemptHeccerName(pcName);

    //- search the registration

    int i;

    for (i = 0 ; i < pnsintegrator->iModelRegistrations ; i++)
    {
	if (!strncmp(pcName, pnsintegrator->psr[i].pcName, strlen(pnsintegrator->psr[i].pcName)))
	{
	    //- and disable it

	    pnsintegrator->psr[i].iDisabled = 1;

	    return 1;
	}
    }

    return 1;
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

  if (pnsintegrator->iModelRegistrations >= MAX_HECCERS)
  {
      fprintf(stdout, "Error: to many heccers in RegisterHeccerName() at %s.\n", pcName);
  }
  else
  {
      pnsintegrator->psr[pnsintegrator->iModelRegistrations].pcName
	  = strdup(pcName);

      pnsintegrator->psr[pnsintegrator->iModelRegistrations].uSolver.si.pheccer
	  = NULL;

      pnsintegrator->psr[pnsintegrator->iModelRegistrations].iType
	  = 1;

      //! Hardcoded check for any name prefixed with "/library"
      //! if so when we disable it.

      if (!strncmp("/library", pcName, strlen("/library")))
      {
	  pnsintegrator->psr[pnsintegrator->iModelRegistrations].iDisabled
	      = 1;
      }
      else
      {
	  pnsintegrator->psr[pnsintegrator->iModelRegistrations].iDisabled
	      = 0;
      }

      pnsintegrator->iModelRegistrations++;
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

    for (i = 0 ; i < pnsintegrator->iModelRegistrations ; i++)
    {
	if (pnsintegrator->psr[i].iDisabled)
	{
	    continue;
	}

	if (InitHeccerObject(&pnsintegrator->psr[i]) == -1)
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
 */
//------------------------------------------------------------------

struct Heccer *LookupHeccerObject(char *pcContext)
{
    struct neurospaces_integrator *pnsintegrator = getNsintegrator();
    int i;

    for (i = 0 ; i < pnsintegrator->iModelRegistrations ; i++)
    {
	if (0 == strcmp(pcContext, pnsintegrator->psr[i].pcName))
	{
	    return(pnsintegrator->psr[i].uSolver.si.pheccer);
	}
    }

    return(NULL);
}



//------------------------------------------------------------------
/*!
 *  \fn int LookupHeccerIndex(char *pcContext)
 *  \return The index which the heccer with the matching context is available at.
 *  \param pcContext name of the Heccer to search
 *  \sa neurospaces_integrator
 *  \sa LookupHeccerObject
 *
 *  Lookup a Heccer instance in the global array and return its index. It
 * will match according to the length of the heccers pcName in the heccer
 * global array. If the heccer instance is disabled then it will not return
 * a valid array index.
 *
 */
//------------------------------------------------------------------
int LookupHeccerIndex(char *pcContext)
{

  struct neurospaces_integrator *pnsintegrator = getNsintegrator();
  int i;
  

  for (i = 0 ; i < pnsintegrator->iModelRegistrations ; i++)
  {
    if (!strncmp(pcContext, pnsintegrator->psr[i].pcName, strlen(pnsintegrator->psr[i].pcName)) )
    {
      if(!pnsintegrator->psr[i].iDisabled)
	return i;

    }
  }

  return -1;

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
int InitHeccerObject(struct SolverRegistration *psr)
{



  if(!psr || psr->iDisabled)
    return;

  struct neurospaces_integrator *pnsintegrator = getNsintegrator();


  //i
  //i First check for a matching neutral element in the model container
  //i before performing a reset. Without a check it can cause a seg fault
  //i or no output.

  //! Mando: interesting comment, but why ?  Can you explain?  Is this
  //! related to hardcoded_neutral ?  If so we need to discuss this
  //! because this 'hidden' logic can hide bugs easily.

  //!
  //! Hugo: Not exactly related to hardcoded neutral but it's just a check
  //! to be sure that the rooted neutral is there. 

  struct PidinStack *ppist = getRootedContext(psr->pcName);
  struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

  if(!phsle)
  {
      fprintf(stdout, "Warning: No neutral rooted object named %s for heccer.\n", psr->pcName);
      return 0;
  }

  PidinStackFree(ppist);

  //i
  //i First check to see if a heccer of a certain name has been created
  //i already. if so exit, this is a secondary check to prevent any 
  //i low level heccers from being created twice.
  //i

  {
/*       struct Heccer *pheccer = LookupHeccerObject(psr->pcName); */

      if (psr->uSolver.si.pheccer)
      {
	  fprintf(stdout,
		  "Warning: Heccer object %s exists, resetting it instead.\n.",
		  psr->uSolver.si.pheccer->pcName);

	  singleHeccerReset(psr->uSolver.si.pheccer);
	  return 0;
      }
  }




  struct Heccer *pheccer = HeccerNew(psr->pcName, NULL, NULL, NULL);

  if(!pheccer){
    fprintf(stderr, "Error allocating Heccer for Context %s\n", psr->pcName);
    return -1;
  }


  pheccer->dStep = clock_value[0];
  
 


  struct Neurospaces *pneuro = 
     pnsintegrator->pelNeurospaces->pneuro;


  //- copy default heccer options

  pheccer->ho = pnsintegrator->pheccerOptions->ho;

  //- and overwrite them with specific options for this instance

  pheccer->ho.iOptions |= psr->uSolver.si.iOptions;

  //- construct the heccer

  HeccerConstruct(pheccer, (void *)pneuro, psr->pcName,NULL);

  //- compile the model

  HeccerCompileP1(pheccer);
  HeccerCompileP2(pheccer);
  HeccerCompileP3(pheccer);

  //- load initial values

  HeccerInitiate(pheccer);

  // \todo add this heccer to the global list come up with a function
  // for adding later.

  // \todo add boundary checking here.

/*   pnsintegrator->psr[pnsintegrator->iModelRegistrations++].uSolver.si.pheccer */
/*       = pheccer; */

  psr->uSolver.si.pheccer = pheccer;

  return 1;

}



