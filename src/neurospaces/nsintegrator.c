//------------------------------------------------------------------
/*!
 *  \file nsintegrator.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for the initialization of
 *  the Neurospaces to GENESIS bridge. 
*/
//-------------------------------------------------------------------
#include "nsintegrator.h"
#include <stdlib.h>




//-------------------------------------------------------------------
/*!
 *  \var struct neurospaces_integrator *pNeurospacesIntegrator
 *
 *  A global datamember which unifies the Genesis to Neurospaces
 *  bridge.
 */
//-------------------------------------------------------------------
struct neurospaces_integrator *pNeurospacesIntegrator = NULL;








//------------------------------------------------------------------
/*!
 *   \fn int NSGenesisInitialize()
 *   \return -1 on error, 1 on success.
 *   \sa neurospaces_integrator
 *
 *   Initializes the pNeurospacesIntegrator.
 */
//------------------------------------------------------------------
int NSGenesisInitialize(){
   

   pNeurospacesIntegrator = 
      (struct neurospaces_integrator*)calloc(1,sizeof(struct neurospaces_integrator));
       
   char	*argvar[5];
   argvar[0] = "c_do_create";
   argvar[1] = "neurospaces";
   argvar[2] = "/model_container";
   do_create(3,argvar);

   pNeurospacesIntegrator->pelNeurospaces = 
      (struct Element*)GetElement("/model_container");
    
       
   char *ppvArgs[] =
   {
      "genesis-neurospaces-bridge",
      "empty_model.ndf",
      NULL,
      NULL,
   };

   //t set NEUROSPACES_MODELS variable to point to where the model can be found  

   pNeurospacesIntegrator->pelNeurospaces->pneuro = 
       NeurospacesNewFromCmdLine(2, &ppvArgs[0]);

   if (!pNeurospacesIntegrator->pelNeurospaces->pneuro)
   {
       fprintf(stderr,
          "Error initializing neurospaces model container\n");
       return -1;

   }


   //t 
   //t Now we cache the root context for easier referencing.
   //t
   pNeurospacesIntegrator->ppistCachedRoot =  PidinStackParse("/");

   pNeurospacesIntegrator->phsleCachedRoot =  
     PidinStackLookupTopSymbol(pNeurospacesIntegrator->ppistCachedRoot);





   //t
   //t create array for storing the neurospaces sumbol table.
   //t
   pNeurospacesIntegrator->iNumSyms = 0; //initial number of symbols is zero

   pNeurospacesIntegrator->ppSymbols = 
     (struct neurospaces_symbol**)calloc(MAX_NSSYMBOLS,sizeof(struct neurospaces_symbol*));


   if( !pNeurospacesIntegrator->ppSymbols ){

     fprintf(stderr,"Error initializing Neurospaces Symbol table\n");
     return -1;

   }



 
   //t
   //t Initializes the Heccer stuff: array + index.
   //t The heccer array is just an array or pointers
   //t to heccer objects.
   //t
   pNeurospacesIntegrator->iHeccers = 0;

   pNeurospacesIntegrator->ppHeccer = 
     (struct Heccer**)calloc(MAX_HECCERS,sizeof(struct Heccer*));


   if( !pNeurospacesIntegrator->ppHeccer ){

     fprintf(stderr,"Error initializing Heccer\n");
     return -1;

   }
    
   
   return 1;

}
