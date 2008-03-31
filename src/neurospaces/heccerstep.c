//------------------------------------------------------------------
/*!
 *  \file heccerstep.c
 *  \author Mando Rodriguez
 *  
 *  This file contains the function implementations for performing
 *  a step on a Heccer instance stored in the global integrator
 *  (pelnsintegrator). 
*/
//-------------------------------------------------------------------
#include "nsintegrator.h"
#include "heccer/heccer.h"





//-------------------------------------------------------------------
/*!
 *   \fn void HeccerReset()
 *   
 *   Performs a reset on all instances of Heccer in the global
 *   array ppheccer located in pelnsintegrator. This is done
 *   by calling the HeccerHecc() function.
 */
//-------------------------------------------------------------------
void HeccerStep(int iMode, double dDuration, int iSteps, int iVerbose){

 
  struct nsintegrator_type *pelnsintegrator
    = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  struct neurospaces_integrator *pnsintegrator
    = pelnsintegrator->pnsintegrator;

  if(!pnsintegrator->ppheccer){

    fprintf(stderr,"ppheccer[] array not allocated, exiting\n");
    exit(0);

  }

  //i get our heccer array and number from out global integrator.
  //i

  struct Heccer **ppheccer = pnsintegrator->ppheccer;
  int iHeccers = pnsintegrator->iHeccers;
  
  
  if(iHeccers == 0){
    
    fprintf(stdout,"No heccer instances allocated\n");
    return;

  }



  int i;
  for(i = 0; i < iHeccers; i++){


    //t
    //t perform a stem via duration
    //t
    printf("\n\n-------------------------------------------------------");
    printf("\tPerforming step with duration %f\n",dDuration);
    HeccerHeccs(ppheccer[i],dDuration);
    singleHeccerStatus(ppheccer[i]); //t print the status for now, we'll remove it later.



  }

  return;


}






