//------------------------------------------------------------------
/*!
 *  \file heccerreset.c
 *  \author Mando Rodriguez
 *  
 *  This file contains the function implementations for performing
 *  a RESET via direct calls to Heccer via the global integrator
 *  (pNeurospacesIntegrator). 
*/
//-------------------------------------------------------------------
#include "nsintegrator.h"
#include "heccer/heccer.h"



//t external declaration of the integrator.
extern struct neurospaces_integrator *pNeurospacesIntegrator;



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







void HeccerReset(){
  
  //t
  //t Create a heccer instance and tag it with "hardcoded_neutral"
  //t which is the same id we give the genesis object all of the 
  //t current objects will be clocked to.
  //t
  HeccerCreate("hardcoded_neutral");
  
  //t the first Heccer will be the only one we're concerned with now.  
  struct Heccer * pHcn = pNeurospacesIntegrator->ppHeccer[0];
  
  singleHeccerStatus(pHcn);

  
}





static void singleHeccerReset(struct Heccer *pheccer){

  if(!pheccer)
    return;
  
  fprintf(stdout,"Heccer Instance (%s):\n",pheccer->pcName);
  fprintf(stdout,"\tStatus: %d\n",pheccer->iStatus);

  HeccerDumpV(pheccer);

  fprintf(stdout,"(dTime) has been set to 0.0\n");
  pheccer->dTime = 0.0;


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
