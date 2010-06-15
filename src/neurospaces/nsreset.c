//------------------------------------------------------------------
/*!
 *  \file nsreset.c
 *  \author Mando Rodriguez
 *  
 *  This file contains the function implementations for performing
 *  a RESET via direct calls to Heccer via the global integrator
 *  (pelnsintegrator). 
*/
//-------------------------------------------------------------------
#include "nsintegrator.h"
#include "ascfile_struct.h"
#include "heccer/addressing.h"
#include "heccer/heccer.h"

//------------------------------------------------------------------
/*
 *  
 */
extern short			nactive_clocks;
extern short			clock_set[NCLOCKS];
extern short			clock_active[NCLOCKS];
extern double			clock_value[NCLOCKS];
//------------------------------------------------------------------



//------------------- static declarations ---------------------------

//-------------------------------------------------------------------
/*!
 *   \fn static void singleHeccerReset(struct Heccer *pheccer)
 *   \param pheccer A pointer to a Heccer struct.
 *   
 *   Performs a RESET on a single Heccer instant passed via parameter
 *   "pheccer."
 */
//-------------------------------------------------------------------
void singleHeccerReset(struct Heccer *pheccer);
static int SetupIOMessages( struct ioMsg **ppioMsg, int iIoMsgs,
			    struct SolverRegistration *psr);


//--------------------------------------------------------------------
/*!
 *   \fn static void singleHeccerStatus(struct Heccer *pheccer)
 *   \param pheccer A pointer to a Heccer struct.
 *
 *   Prints out all of the status info in a heccer struct.
 */
//--------------------------------------------------------------------



//------------------- end static declarations ------------------------





//-----------------------------------------------------------------------
/*!
 *   \fn void NSReset()
 *   
 *   Performs a reset on all heccer objects stored in the 
 *   neurospaces_integrator
 */
//-----------------------------------------------------------------------
int NSReset(){  

  
  struct neurospaces_integrator  *pnsintegrator = getNsintegrator();

  if(!pnsintegrator)
    return -1;


  if (!TranslateSolverNames(pnsintegrator))
  {
      return -1;
  }

  //-
  //- Now add annotated variables since the heccer instance has
  //- been created. We set up messages for each heccer instance.
  //-

  struct ioMsg **ppioMsg = pnsintegrator->ppioMsg;
/*   struct Heccer **ppheccer = pnsintegrator->ppheccer;  */
  int iIoMsgs = pnsintegrator->iIoMsgs;
  int iHeccers = pnsintegrator->iModelRegistrations;

  int i;

  for( i = 0; i < iHeccers; i++ )
  {
      // when can this heccer be NULL?
      // in any simple scripts seems, but only the first entry in the array.
      // \todo that is a mystery.
      //i This has been modified to use a new parameter pass for a solver registration.

      if (pnsintegrator->psr[i].pcName)
      {
	  SetupIOMessages(ppioMsg, iIoMsgs, &pnsintegrator->psr[i]);
      }
  }

  return 1;

  
}





//-----------------------------------------------------------------------
/*!
 *   \fn static int SetupIOMessages( struct ioMsg **ppioMsg, int iIoMsgs,
			  struct SolverRegistration *psr)
 *   \param ppioMsg A pointer to the array of pointer IO messages
 *   \param iIoMsgs The number of IO messages in the ppioMsg array
 *   \param psr A pointer to a solver registration object. 
 *
 *   
 */
//-----------------------------------------------------------------------
static int SetupIOMessages( struct ioMsg **ppioMsg, int iIoMsgs,
			  struct SolverRegistration *psr)
{
  int i;

  if(!psr)
    return -1;

  for(i = 0; i < iIoMsgs; i++)
  {

    if(!strcmp(ppioMsg[i]->pcMsgName, "SAVE"))
    {
	//- every reset triggers this function, so may be

	//- if this message is already integrated in the run-time

	if (ppioMsg[i]->iRunTime)
	{
	    //- skip

	    continue;
	}

      struct ascfile_type *pasc = 
	(struct ascfile_type*)GetElement(ppioMsg[i]->pcTargetSymbol);

      //- if the asc object did not receive a RESET yet, it did not
      //- create the output generator, which can be detected overhere.

      if (!pasc->pog)
      {
	  if (AscReset(pasc) == -1)
	  {
	      Error();
	      fprintf
		  (stdout,
		   "Error: resetting asc_file %s\n",
		   pasc->name);
	  }
      }

      struct PidinStack *ppist = 
	PidinStackParse(ppioMsg[i]->pcSourceSymbol);

      PidinStackUpdateCaches(ppist);
      
      ppioMsg[i]->iTarget = PidinStackToSerial(ppist);

 
      double *pdValue = NULL;

      if(psr->iType == SOLVER_HECCER)
      {

	if(psr->uSolver.si.pheccer)
	{

	  pdValue = HeccerAddressVariable(psr->uSolver.si.pheccer, 
					  ppioMsg[i]->iTarget, 
					  ppioMsg[i]->pcSourceField);

	}
	else
	{
	  continue;
	}

      }
      else if(psr->iType == SOLVER_PULSEGEN)
      {

	
	struct pulsegen_type *ppgt = (struct pulsegen_type*)(GetElement(psr->pcName));

	if(!ppgt)
	{

	  fprintf(stdout,"No element named %s to setup IO for.\n",psr->pcName);

	  continue;

	}
	else
	{

	  if(ppgt->pdOutput)
	  {

	    pdValue = ppgt->pdOutput;

	  }

	}

      }



      if (pdValue)
      {
	  OutputGeneratorAddVariable(pasc->pog,
				     ppioMsg[i]->pcSourceField,
				     (void *)pdValue);
      }
      else
      {
	  Error();
	  fprintf
	      (stdout,
	       "Error: cannot find output fields for asc_file %s\n",
	       pasc->name);
      }


      //- register that this message was integrated in the run-time

      ppioMsg[i]->iRunTime = 1;

    }

  }


  return 1;

}





/* static int SetupIOMessages( struct ioMsg **ppioMsg, int iIoMsgs, */
/* 			  struct Heccer *pheccer) */
/* { */
/*   int i; */

/*   for(i = 0; i < iIoMsgs; i++) */
/*   { */

/*     if(!strcmp(ppioMsg[i]->pcMsgName, "SAVE")) */
/*     { */
/* 	//- every reset triggers this function, so may be */

/* 	//- if this message is already integrated in the run-time */

/* 	if (ppioMsg[i]->iRunTime) */
/* 	{ */
/* 	    //- skip */

/* 	    continue; */
/* 	} */

/*       struct ascfile_type *pasc =  */
/* 	(struct ascfile_type*)GetElement(ppioMsg[i]->pcTargetSymbol); */

/*       //- if the asc object did not receive a RESET yet, it did not */
/*       //- create the output generator, which can be detected overhere. */

/*       if (!pasc->pog) */
/*       { */
/* 	  if (AscReset(pasc) == -1) */
/* 	  { */
/* 	      Error(); */
/* 	      fprintf */
/* 		  (stdout, */
/* 		   "Error: resetting asc_file %s\n", */
/* 		   pasc->name); */
/* 	  } */
/*       } */

/*       struct PidinStack *ppist =  */
/* 	PidinStackParse(ppioMsg[i]->pcSourceSymbol); */

/*       PidinStackUpdateCaches(ppist); */
      
/*       ppioMsg[i]->iTarget = PidinStackToSerial(ppist); */

 
/*       double *pdValue */
/* 	  = HeccerAddressVariable(pheccer,  */
/* 				  ppioMsg[i]->iTarget,  */
/* 				  ppioMsg[i]->pcSourceField); */

/*       if (pdValue) */
/*       { */
/* 	  OutputGeneratorAddVariable(pasc->pog, */
/* 				     ppioMsg[i]->pcSourceField, */
/* 				     (void *)pdValue); */
/*       } */
/*       else */
/*       { */
/* 	  Error(); */
/* 	  fprintf */
/* 	      (stdout, */
/* 	       "Error: cannot find output fields for asc_file %s\n", */
/* 	       pasc->name); */
/*       } */


/*       //- register that this message was integrated in the run-time */

/*       ppioMsg[i]->iRunTime = 1; */

/*     } */

/*   } */


/*   return 1; */

/* } */




void singleHeccerReset(struct Heccer *pheccer){

  if(!pheccer)
    return;
 

  pheccer->dTime = 0.0;
  pheccer->dStep = clock_value[0]; //when reset this is set to clock zero.

}





void singleHeccerStatus(struct Heccer * pheccer){

  if(!pheccer)
    return;
  
   fprintf(stdout,"Heccer Instance (%s):\n",pheccer->pcName); 
   fprintf(stdout,"\tStatus (iStatus): %d\n",pheccer->iStatus); 
   fprintf(stdout,"\tCurrent time (dTime): %F\n",pheccer->dTime); 
  fprintf(stdout,"\tTime step (dStep): %F\n",pheccer->dStep); 
  HeccerDumpV(pheccer);
  
}
