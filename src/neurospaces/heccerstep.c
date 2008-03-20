//------------------------------------------------------------------
/*!
 *  \file heccerstep.c
 *  \author Mando Rodriguez
 *  
 *  This file contains the function implementations for performing
 *  a step on a Heccer instance stored in the global integrator
 *  (pNeurospacesIntegrator). 
*/
//-------------------------------------------------------------------
#include "nsintegrator.h"
#include "heccer/heccer.h"


//t external declaration of the integrator.
extern struct neurospaces_integrator *pNeurospacesIntegrator;



//-------------------------------------------------------------------
/*!
 *   \fn void HeccerReset()
 *   
 *   Performs a reset on all instances of Heccer in the global
 *   array ppHeccer located in pNeurospacesIntegrator. This is done
 *   by calling the HeccerHecc function.
 */
//-------------------------------------------------------------------
void HeccerStep(int iMode, double dDuration, int iSteps, int iVerbose){

 
  if(!pNeurospacesIntegrator->ppHeccer){

    fprintf(stderr,"Heccer array not allocated, exiting\n");
    exit(0);

  }

  //i get our heccer array and number from out global integrator.
  //i
  struct Heccer **ppheccer = pNeurospacesIntegrator->ppHeccer;
  int iheccers = pNeurospacesIntegrator->iHeccers;
  
  
  if(iheccers == 0){
    
    fprintf(stdout,"No heccer instances allocated\n");
    return;

  }



  int i;
  for(i = 0; i < iheccers; i++){


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






