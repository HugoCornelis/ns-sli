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


