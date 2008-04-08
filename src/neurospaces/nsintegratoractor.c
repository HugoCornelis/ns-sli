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






//-------------------------------------------------------------
/*!
 *   \fn int NeurospacesIntegratorActor(struct nsintegrator_type *pnsintegrator_type, Action *action)
 *   \param nsintegrator_type A data member passed by the GENESIS SLI.
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
	printf("LOL WUT\n");
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

	struct Heccer **ppheccer = pnsintegrator->ppheccer;
	printf("Dumping Heccer status:\n");
	for(i=0;i<pnsintegrator->iHeccers;i++)
	  HeccerDumpV(ppheccer[i]);
	
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
	printf("BLARG\n");
	for(i=0;i<pnsintegrator->iHeccers;i++)
	  HeccerHeccs(ppheccer[i], 
		      ppheccer[i]->dTime + ppheccer[i]->dStep);
	
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

	printf("Performing a reset on all Heccers\n");
	  SymbolRecalcAllSerials(pnsintegrator->phsleCachedRoot, 
                         pnsintegrator->ppistCachedRoot);

	  
	  HeccerReset();

	  break;
      }




    }

    //- return result

    return(iResult);
}


