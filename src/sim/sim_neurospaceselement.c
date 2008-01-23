#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"


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
int CreateNeurospacesElement(char* name, Element* parent, Action* action,int index){

   struct symtab_Segment* segment = NULL;
   char* pathname = NULL;
   struct PidinStack* ppist = NULL;
   struct symtab_HSolveListElement* phsle = NULL;
   
   
   segment = SegmentCalloc();
   
   if( !segment ){

     fprintf(stderr,"Error allocating compartment %s\n",name);
     return -1;

   }


   pathname = Pathname(parent);
   /* fprintf(stdout,"Pathname: %s\n",pathname); */
  

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
  
   SymbolAddChild(phsle,segment);
   

   int a = SymbolRecalcAllSerials(phsle,ppist);   
   
   printf("gives me %d\n",a);
   return 0;

}







