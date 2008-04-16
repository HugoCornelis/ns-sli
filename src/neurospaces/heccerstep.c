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

 */
//-------------------------------------------------------------------
void HeccerStep(int iMode, double dSimulationTime, int iSteps, int iVerbose){

 
  struct nsintegrator_type *pelnsintegrator
    = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  struct neurospaces_integrator *pnsintegrator
    = pelnsintegrator->pnsintegrator;

  if(!pnsintegrator->ppheccer){

    fprintf(stderr,"Heccer table no initialized, exiting\n");
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

    HeccerHeccs(ppheccer[i], 
	     ppheccer[i]->dTime + ppheccer[i]->dStep);
    
    fprintf("Heccer Instance (%s): ",ppheccer[i]->pcName);
    fprintf(stdout,"time = %f ; step = %d          ",
	    dSimulationTime,  ppheccer[i]->dTime);
  }

  return;


}






