//------------------------------------------------------------------
/*!
 *  \file nspulsegen.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for creating a pulsegen object
 * within the ns-sli.
*/
//-------------------------------------------------------------------
#include <stdio.h>


#include "nsintegrator.h"
#include "pulsegen_struct.h"


//------------------------------------------------------------------
/*
 * Si,ulator variables assigned in the sim code.
 */
extern short			nactive_clocks;
extern short			clock_set[NCLOCKS];
extern short			clock_active[NCLOCKS];
extern double			clock_value[NCLOCKS];
//------------------------------------------------------------------





//------------------------------------------------------------------
/*!
 *  \fn int AttemptSolverName(char *pcName)
 *
 *  \return -1 on error, 1 on success, 0 for no operation.
 *
 */

//------------------------------------------------------------------
int AttemptPulseGenName(char *pcName)
{
    struct neurospaces_integrator *pnsintegrator = getNsintegrator();

    //- if this name is in the proto library

    if (strncmp(pcName, "/proto", strlen("/proto")) == 0)
    {
	//- this is assumed to be disabled, so return success

	return 0;
    }

    //- if a solver object with the same name exists.

    int i;

    for (i = 0 ; i < pnsintegrator->iModelRegistrations ; i++)
    {
	if (strncmp(pcName, pnsintegrator->psr[i].pcName, strlen(pnsintegrator->psr[i].pcName)) == 0)
	{
	    //- if so we don't register the name and exit with success.

	    return 0;
	}

	if (strncmp(pnsintegrator->psr[i].pcName, pcName, strlen(pcName)) == 0)
	{
	    //- or we overwrite the existing entry with a name that
	    //- catches more of the model

	    free(pnsintegrator->psr[i].pcName);

	    pnsintegrator->psr[i].pcName = strdup(pcName);

	    return 0;
	}
    }

    //- no heccer with that name, so register a new one

    return(RegisterPulseGenName(pcName));
}





//------------------------------------------------------------------
/*!
 *  \fn int RegisterPulseGenName(char *pcName)
 *
 *  \return -1 on error, 1 on success, 0 for no operation.
 *
 */

//------------------------------------------------------------------
int RegisterPulseGenName(char *pcName)
{

  struct neurospaces_integrator *pnsintegrator = getNsintegrator();

  //- register the name of the heccer object

  if (pnsintegrator->iModelRegistrations >= MAX_HECCERS)
  {
      fprintf(stdout, "Error: to many heccers in RegisterHeccerName() at %s.\n", pcName);
  }
  else
  {

      pnsintegrator->psr[pnsintegrator->iModelRegistrations].pcName
	  = strdup(pcName);


      if (pnsintegrator->psr[pnsintegrator->iModelRegistrations].pcName[strlen(pnsintegrator->psr[pnsintegrator->iModelRegistrations].pcName) - 1] == '/')
      {
	  pnsintegrator->psr[pnsintegrator->iModelRegistrations].pcName[strlen(pnsintegrator->psr[pnsintegrator->iModelRegistrations].pcName) - 1] = '\0';
      }

      pnsintegrator->psr[pnsintegrator->iModelRegistrations].uSolver.ppg
	  = NULL;

      pnsintegrator->psr[pnsintegrator->iModelRegistrations].iType
	  = SOLVER_PULSEGEN;


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

}




//---------------------------------------------------------
/*!
 *  \fn int PulseGenReset(char *name)
 *  \param name The name of the pulsegen object to reset.
 *  \return -1 on error, 1 on success.
 */
//---------------------------------------------------------
int NSPulseGenReset(struct pulsegen_type *ppgt)
{

  //-
  //- If the pulsegen is not already allocated then we 
  //- allocate it here.
  //-
  if(!ppgt->ppg)
  {

    ppgt->ppg = PulseGenNew(ppgt->name);

    if(!ppgt->ppg)
    {

      fprintf(stdout,
	      "Error: Could not create pulsegen object \" %s\".\n",
	      ppgt->name);

      return -1;

    }


    if(!PulseGenSetFields(ppgt->ppg, 
			  ppgt->level1, ppgt->width1, ppgt->delay1, 
			  ppgt->level2, ppgt->width2, ppgt->delay2, 
			  ppgt->baselevel, ppgt->trig_mode))
    {
      fprintf(stdout,
	      "Error: Could not initialize pulsegen object \" %s\".\n",
	      ppgt->name);
      return -1;
    }

    //- Set the output
    if(!PulseGenAddVariable(ppgt->ppg,(void*)&(ppgt->output)))
    {

      fprintf(stdout,"Error: Could not set output for pulsegen %s\n",ppgt->name);

    }

  }

  return 1;
}


