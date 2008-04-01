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





//------------------------------------------------------------------
/*!
 *   \fn int NSGenesisInitialize()
 *   \return -1 on error, 1 on success.
 *   \sa neurospaces_integrator
 *
 *   Initializes the pnsintegrator.
 */
//------------------------------------------------------------------
int NSGenesisInitialize(){
   

  struct neurospaces_integrator *pnsintegrator = 
      (struct neurospaces_integrator *)calloc(1,sizeof(struct neurospaces_integrator));
       
   char	*argvar[5];
   argvar[0] = "c_do_create";
   argvar[1] = "neurospaces";
   argvar[2] = "/model_container";
   do_create(3,argvar);

   pnsintegrator->pelNeurospaces = 
      (struct neurospaces_type *)GetElement("/model_container");
    
       
   char *ppvArgs[] =
   {
      "genesis-neurospaces-bridge",
      "empty_model.ndf",
      NULL,
      NULL,
   };

   //t set NEUROSPACES_MODELS variable to point to where the model can be found  

   pnsintegrator->pelNeurospaces->pneuro = 
       NeurospacesNewFromCmdLine(2, &ppvArgs[0]);

   if (!pnsintegrator->pelNeurospaces->pneuro)
   {
       fprintf(stderr,
          "Error initializing neurospaces model container\n");
       return -1;

   }



   //t 
   //t Now we cache the root context for easier referencing.
   //t
   pnsintegrator->ppistCachedRoot =  PidinStackParse("/");

   pnsintegrator->phsleCachedRoot =  
     PidinStackLookupTopSymbol(pnsintegrator->ppistCachedRoot);





   //t
   //t create array for storing the neurospaces sumbol table.
   //t
   pnsintegrator->iNumSyms = 0; //initial number of symbols is zero

   pnsintegrator->ppSymbols = 
     (struct neurospaces_symbol**)calloc(MAX_NSSYMBOLS,sizeof(struct neurospaces_symbol*));


   if( !pnsintegrator->ppSymbols ){

     fprintf(stderr,"Error initializing Neurospaces Symbol table\n");
     return -1;

   }



 
   //t
   //t Initializes the Heccer stuff: array + index.
   //t The heccer array is just an array or pointers
   //t to heccer objects.
   //t
   pnsintegrator->iHeccers = 0;

   pnsintegrator->ppheccer = 
     (struct Heccer**)calloc(MAX_HECCERS,sizeof(struct Heccer*));


   if( !pnsintegrator->ppheccer ){

     fprintf(stderr,"Error initializing Heccer\n");
     return -1;

   }
    
   
     char	*argvar2[5];  
     argvar2[0] = "c_do_create";  
     argvar2[1] = "nsintegrator";  
     argvar2[2] = "/neurospaces_integrator";  
     do_create(3,argvar2);  

     struct nsintegrator_type *pelnsintegrator =   
        (struct nsintegrator_type*)GetElement("/neurospaces_integrator");  

     if(!pelnsintegrator){ 
      
       fprintf(stderr, 
 	      "Unable to create Neurospaces Integrator Object\n"); 
      
       exit(1); 
     } 


   pelnsintegrator->pnsintegrator = pnsintegrator; 

   return 1;

}
