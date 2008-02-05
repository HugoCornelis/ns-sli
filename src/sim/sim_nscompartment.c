#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

#include "neurospaces/neurospaces_ext.h"

#include "neurospaces/segment.h"  
#include "neurospaces/symbols.h"  
#include "neurospaces/symboltable.h"  
#include "neurospaces/pidinstack.h"

/************************************************
 *
 * CreateNeurospacesElement: Creates a "segment" which
 * coorresponds to the GENESIS compartment.
 *
 *
 ***********************************************/
int CreateNeurospacesElement(char* name, Element* pelParent, Action* action,int index){

   struct symtab_Segment* psegment = NULL;
   char* pathname = NULL;
   struct PidinStack* ppist = NULL;
   struct symtab_HSolveListElement* phsle = NULL;
   struct symtab_IdentifierIndex* pidin;
   static struct neurospaces_type *pelNeurospaces = NULL;


   // struct Neurospaces *pneuro = NULL; 

   if (pelNeurospaces == NULL)
     {
       {
	 char	*argvar[5];
	 argvar[0] = "c_do_create";
	 argvar[1] = "neurospaces";
	 argvar[2] = "/model_container";
	 do_create(3,argvar);

	 pelNeurospaces = (struct Element*)GetElement("/model_container");
       }
       {
	 char *ppvArgs[] =
	   {
	     "genesis-neurospaces-bridge",
	     "empty_model.ndf",
	     NULL,
	     NULL,
	   };

	 //t set NEUROSPACES_MODELS variable to point to where the model can be found

         pelNeurospaces->pneuro = NeurospacesNewFromCmdLine(2, &ppvArgs[0]);

	 if (!pelNeurospaces->pneuro)
	   {
	     fprintf(stderr,"Error initializing neurospaces model container during %s processing\n",name);
	     return -1;

	   }
       }
     }
   
   //pneuro = pelNeurospaces->pneuro; 

   psegment = SegmentCalloc();
   
   if( !psegment ){

     fprintf(stderr,"Error allocating compartment %s\n",name);
     return -1;

   }


   char *pnewname = strdup(name);
   pidin = IdinNewFromChars(pnewname);
   SymbolSetName(&psegment->segr.bio.ioh.iol.hsle,pidin); 
   

 
   pathname = Pathname(pelParent); 
 /*   fprintf(stdout,"Pathname: %s\n",pathname);  */
  
   ppist = PidinStackParse(pathname);
  


   if( !ppist ){

     fprintf(stderr,"Error creating Pidin for %s", name);
     return -1;
   
   }

   
   phsle = PidinStackLookupTopSymbol(ppist);  
   
   if( !phsle ){ 

      fprintf(stderr,"Error performing Pidin Lookup on %s\n",name); 
      return -1; 
   
   } 
  
   
   
   SymbolAddChild(phsle, &psegment->segr.bio.ioh.iol.hsle);
   

   SymbolRecalcAllSerials(phsle,ppist);    
   return 1;

}







