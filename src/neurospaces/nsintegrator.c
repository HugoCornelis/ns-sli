#include "nsintegrator.h"
#include <stdlib.h>



//t
//t  A global datamember which unifies the Genesis to Neurospaces
//t  bridge.
//t 
struct neurospaces_integrator *pNeurospacesIntegrator = 0;



//t  Function initializes the Neurospaces data
//t  members for use in GENESIS.
//t
//t
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


   //t Now instantiate the heccer instances.
   //t
   pNeurospacesIntegrator->pheccer = 
     (struct pheccer *)calloc(1,sizeof(struct Heccer));

   if( !pNeurospacesIntegrator->pheccer ){

     fprintf(stderr,"Error initializing Heccer\n");
     return -1;
   }
  
   pNeurospacesIntegrator->iHeccers = 0;

   return 1;

}
