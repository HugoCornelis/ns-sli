//------------------------------------------------------------
/*!
 *   \file nsintegratoractor.c
 *   \author Mando Rodriguez
 *
 *   File holes the NeurospacesIntegratorActor for SLI calls to
 *   neurospaces functions.
 */
//-------------------------------------------------------------
#include "nsintegrator.h"
#include "nsintegrator_g@.h"


extern int iNSIntegratorVerbose;


//------------------------------------------------------------------
/*
 *  
 */
extern short			nactive_clocks;
extern short			clock_set[NCLOCKS];
extern short			clock_active[NCLOCKS];
extern double			clock_value[NCLOCKS];
//------------------------------------------------------------------






//-------------------------------------------------------------
/*!
 *   \fn int NeurospacesIntegratorActor(struct nsintegrator_type *pnsintegrator_type, Action *action)
 *   \param pnsintegrator_type A data member passed by the GENESIS SLI.
 *   \param action An action call passed from the GENESIS SLI.
 *   \return 1 is call was ok, -1 on error.
 *   \sa neurosapces_integrator   
 *
 *   This is the actor function which performs actions on the 
 *   neurospaces_integrator when it's being called by GENESIS.
 *
 */
//-------------------------------------------------------------
int NeurospacesIntegratorActor(struct nsintegrator_type *pnsintegrator_type,
			       Action *action){

  
  struct neurospaces_integrator *pnsintegrator = 
    pnsintegrator_type->pnsintegrator;


  int i;

  
    //- set default result : ok
    int iResult = 1;

    //- select action

    SELECT_ACTION(action)
    {

      //- create



    case CREATE:
      {
   
	break;
      }



    case CHECK:
      {
	//t check all heccer clocks: within limits ?
	break;
      }



      /*************************************
       *
       * This action prints out the verbose contents
       * of every heccer instance.
       *
       ************************************/
    case NSINTEGRATOR_DUMP:
      {
	int iSelection = 1;

	nsintegrator_dump(pnsintegrator_type, 
			  iSelection,
			  pnsintegrator_type->heccer_dump_selection);

	break;
      }



      /***************************************
       *
       * performs a single step on every heccer
       * instance.
       *
       ***************************************/
    case PROCESS:
      {

	struct Heccer **ppheccer = pnsintegrator->ppheccer;

       

	for(i=0;i<pnsintegrator->iHeccers;i++)
	{



	  // need to link to "double simulation_time" in sim_step.c
          //	
	  HeccerHeccs(ppheccer[i],simulation_time + clock_value[0]);
 
 

	  if (iNSIntegratorVerbose == 1)
	  {
	    if(((GetCurrentStep()+1)%pnsintegrator_type->heccer_reporting_granularity) != 0)
	      return iResult;

	    fprintf(stdout,"%s: time = %lf ; step = %lf          \n",
		    ppheccer[i]->pcName,
		    ppheccer[i]->dTime,
		    ppheccer[i]->dStep);
	  }

	  if (iNSIntegratorVerbose == 2)
	  {

	    if(((GetCurrentStep())%pnsintegrator_type->heccer_reporting_granularity) != 0)
	      return iResult;

	    nsintegrator_dump(pnsintegrator_type, 
			      1,
			      pnsintegrator_type->heccer_dump_selection);
	  }
	}
	
	break;
      }

       

      /***************************************
       *
       * performs a "reset" action on every 
       * heccer instance we've created.
       *
       ***************************************/
    case RESET:
      {

	SymbolRecalcAllSerials(pnsintegrator->phsleCachedRoot, 
                         pnsintegrator->ppistCachedRoot);

	  
        NSReset();

	break;
      }




    }

    //- return result

    return(iResult);
}


