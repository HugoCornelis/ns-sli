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



//------------------------------------------------------------------
/*!
 *  \fn int RegisterSolverName(char *pcName,int iType)
 *
 *  \return -1 on error, 1 on success, 0 for no operation.
 *
 */

//------------------------------------------------------------------
int RegisterSolverName(char *pcName,int iType)
{

  int iResult = 0;

  if(iType == SOLVER_HECCER)
  {
    
    iResult = RegisterHeccerName(pcName);

    return iResult;

  }
  else if(iType == SOLVER_PULSEGEN)
  {

    return iResult RegisterPulseGenName(pcName);

  }

  return iResult;

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
      //- Only meant to be set on heccer solvers.

      if(pnsintegrator->psr[i].iType == SOLVER_HECCER)
      {
	pnsintegrator->psr[i].uSolver.si.iOptions |= iOptions;

	return 1;
      }
      else
      {
	return -1;
      }

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
 *  \fn int LookupSolverIndex(char *pcContext)
 *  \return The index which the heccer with the matching context is available at.
 *  \param pcContext name of the Heccer to search
 *  \sa neurospaces_integrator
 *  \sa LookupHeccerObject
 *
 *  Lookup a Solver instance in the global array and return its index. It
 * will match according to the length of the solvers pcName in the heccer
 * global array. If the heccer instance is disabled then it will not return
 * a valid array index.
 *
 */
//------------------------------------------------------------------
int LookupSolverIndex(char *pcContext)
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
int InitSolverObject(struct SolverRegistration *psr)
{


  if(!psr || psr->iDisabled)
    return;

  int iResult = 0;

  if(psr->iType == SOLVER_HECCER)
  {
    iResult = InitHeccerObject(psr);
  }
  else if(psr->iType == SOLVER_PULSEGEN)
  {
    iResult = InitPulseGenObject(psr);
  }
  else
  {
    iResult = -1;
  }

  return iResult;

}



//------------------------------------------------------------------
/*!
 *  \fn int InitPulseGenObject()
 *
 *  \param psr A solver registration object with the necessary data to create a pulsegen.
 *  \return -1 on error, 1 on success, 0 for no operation.
 *  \sa neurospaces_integrator
 *
 */
//------------------------------------------------------------------
int InitPulseGenObject(struct SolverRegistration *psr)
{


  return 1;
}




