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
#include "heccer/heccer.h"
#include "ascfile_struct.h"

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
static void singleHeccerReset(struct Heccer *pheccer);


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
void NSReset(){  

  
  struct nsintegrator_type *pelnsintegrator
    = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  struct neurospaces_integrator *pnsintegrator
    = pelnsintegrator->pnsintegrator;


  //t The first Heccer will be the only one we're concerned with now.  
  struct Heccer * pheccer = pnsintegrator->ppheccer[0];



  if(!pheccer){

  //t
  //t Create a heccer instance and tag it with "hardcoded_neutral"
  //t which is the same id we give the genesis object all of the 
  //t current objects will be clocked to.
  //t
    HeccerCreate(MODELCONTAINER_ROOT);

  }
  else
    singleHeccerReset(pheccer);


  //-
  //- Now add annotated variables since the heccer instance has
  //- been created.
  //-
  int i;

  struct ioMsg **ppioMsg = pnsintegrator->ppioMsg;
  int iIoMsgs = pnsintegrator->iIoMsgs;


  for(i = 0; i < iIoMsgs; i++)
  {

    if(!strcmp(ppioMsg[i]->pcMsgName,"save"))
    {

      struct ascfile_type *pasc = 
	(struct ascfile_type*)GetElement(ppioMsg[i]->pcTargetSymbol);

      if(!pasc)
	continue;

      struct PidinStack *ppist = 
	PidinStackParse(ppioMsg[i]->pcSourceSymbol);

      PidinStackUpdateCaches(ppist);
      
      ppioMsg[i]->iSerial = PidinStackToSerial(ppist);

      //- only do this with one heccer for now. 
      double *pdValue
	= (double *)HeccerAddressVariable(pnsintegrator->ppheccer[0], 
				ppioMsg[i]->iSerial, 
				ppioMsg[i]->pcSourceField);

      OutputGeneratorAddVariable(pasc->pog,
				 ppioMsg[i]->pcSourceField,
				 (void *)pdValue);


    }

  }

  
}




static void singleHeccerReset(struct Heccer *pheccer){

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
