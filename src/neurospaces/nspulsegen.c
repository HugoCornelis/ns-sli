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


//------------------------------------------------------------------
/*!
 *  \fn int InitPulseGenObject()
 *
 *  \param pcContext A char array holding the name for the PulseGen to create.
 *  \return -1 on error, 1 on success, 0 for no operation.
 *  \sa neurospaces_integrator
 *  \sa InitHeccerObject
 *
 *  Creates a PulseGen instace and stores it in the global solver
 *  array in pelnsintegrator.
 *
 */
//------------------------------------------------------------------
int InitPulseGenObject(struct SolverRegistration *psr)
{


  if(!psr || psr->iDisabled)
    return 0;

  struct neurospaces_integrator *pnsintegrator = getNsintegrator();

  //- The primary linking between the pulsegen object and the pulsegen solver
  //- is made at the genesis 2 level. So we retrieve the genesis 2 object for 
  //- this pulsegen, create a solver and link it "ppg" pointer. This is where it
  //- is looked for in the PulseGenActor function.

  if(!psr->pcName)
    return -1;

  struct pulsegen_type *ppgt = (struct pulsegen_type*)(GetElement(psr->pcName));

  if(!ppgt)
  {
    fprintf(stdout,"Error: No pulsegen element named %s found, cannot attach a solver.\n");
  }

  
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


  }

  return 1;

}
