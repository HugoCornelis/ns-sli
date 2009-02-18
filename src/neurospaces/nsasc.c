//------------------------------------------------------------------
/*!
 *  \file nsasc.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for ascii output from a 
 *  heccer object accessible in the ns-sli.
*/
//-------------------------------------------------------------------
#include <stdio.h>


#include "nsintegrator.h"
#include "ascfile_struct.h"


//------------------------------------------------------------------
/*
 * These are   
 */
extern short			nactive_clocks;
extern short			clock_set[NCLOCKS];
extern short			clock_active[NCLOCKS];
extern double			clock_value[NCLOCKS];
//------------------------------------------------------------------




//---------------------------------------------------------

//---------------------------------------------------------

int AscStep(struct ascfile_type *pasc)
{


  
  OutputGeneratorTimedStep(pasc->pog, simulation_time);


  return 1;

}




//---------------------------------------------------------
/*!
 *  \fn int NSAscReset(char *name)
 *  \param name The name of the asc_file object to reset.
 *  \return -1 on error, 1 on success.
 */
//---------------------------------------------------------
int AscReset(struct ascfile_type *pasc)
{

  //-
  //- If the output generator is not already allocated then we 
  //- allocate it here.
  //-
  if(!pasc->pog)
  {

    pasc->pog = OutputGeneratorNew(pasc->filename);

    if(!pasc->pog)
    {

      fprintf(stdout,
	      "Error: Could not create file %s for asc_object %s.\n",
	      pasc->filename,
	      pasc->name);

      return -1;

    }

  }


  if(OutputGeneratorInitiate(pasc->pog) == -1)
  {

    fprintf(stdout,
	    "Error: Cound open file \"%s\" for write in asc_file %s\n",
	    pasc->filename,
	    pasc->name);

    return -1;

  }


  return 1;
}



/*!
 * \fn int NSProcessMessages(struct neurospaces_integrator *pnsintegrator)
 * \param pnsintegrator A pointer to the neurospace integrator struct.
 * \return -1 on error, 1 on success.
 *
 */
int NSProcessMessages(struct neurospaces_integrator *pnsintegrator)
{

  int i;

  struct ioMsg **ppioMsg = pnsintegrator->ppioMsg;

  struct Heccer **ppheccer = pnsintegrator->ppheccer;

  if(!ppioMsg)
    return -1;

  for (i = 0 ; i < NUMBER_OF_ASC_MESSAGES ; i++) 
  {

    if(ppioMsg[i]->pcSourceSymbol)
    {
      //- resolve source

      struct PidinStack *ppistSource
	= PidinStackParse(ppioMsg[i]->pcSourceSymbol);

      struct symtab_HSolveListElement *phsleSource
	= PidinStackLookupTopSymbol(ppistSource);

      //- fetch value

      ppioMsg[i]->dValue
	= SymbolParameterResolveValue(phsleSource, ppistSource, ppioMsg[i]->pcSourceField);

      //- resolve target

      struct PidinStack *ppistTarget
	= PidinStackParse(ppioMsg[i]->pcTargetSymbol);

      PidinStackUpdateCaches(ppistTarget);

      int iTarget = PidinStackToSerial(ppistTarget);

      double *pdValue
	= HeccerAddressVariable(ppheccer[0], iTarget, ppioMsg[i]->pcTargetField);

      //- add source to target

      *pdValue += ppioMsg[i]->dValue;

    }

  }

  return 1;

}
