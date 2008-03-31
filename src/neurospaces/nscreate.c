//------------------------------------------------------------------
/*!
 *  \file nscreate.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for creating objects in
 *  the Neurospaces Model Container via the GENESIS scripting 
 *  language.
*/
//-------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"


#include "neurospaces/segment.h"  
#include "neurospaces/symbols.h"  
#include "neurospaces/symboltable.h"  
#include "neurospaces/pidinstack.h"

//t includes from our nsgenesis library
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/nsintegrator.h"




/**************************************************************************
 *
 *   NeurospacesCreate: A generic function which allocates 
 **************************************************************************/

int NeurospacesCreate( char* name,  Element* pelParent, int iChild){

   struct symtab_HSolveListElement *phsleChild = NULL;
   struct PidinStack* ppistParent = NULL;
   struct symtab_HSolveListElement* phsleParent = NULL;
   struct symtab_IdentifierIndex* pidinChild;

   //- if there is no parent given

   if (!pelParent)
     {
       //- assume we are creating a root element on initialization.

       //! normally genesis creates an element without parent for default values,
       //! and a second element without parent for the root element

       return 1;
     }


   switch(iChild){


   case NSINTEGRATOR_COMPARTMENT:
     phsleChild = (struct symtab_HSolveListElement*)SegmentCalloc();
     break;

   case NSINTEGRATOR_NEUTRAL:
     phsleChild = (struct symtab_HSolveListElement*)CellCalloc();
     break;
   }
 
   

   if( !phsleChild ){

     fprintf(stderr,"Error allocating phsleChild for:%s\n",name);
     return -1;

   }


   char *pcChild = strdup(name);
   pidinChild = IdinNewFromChars(pcChild);
   SymbolSetName(phsleChild, pidinChild); 
   

 
   char *pcParent = Pathname(pelParent);
   ppistParent = PidinStackParse(pcParent);
  

   if( !ppistParent ){

     fprintf(stderr,"Error creating symbol: %s\n", name);
     return -1;
   
   }
  
   phsleParent = PidinStackLookupTopSymbol(ppistParent);  
   
   if( !phsleParent ){ 

      fprintf(stderr,"Error:Symbol (%s) not found\n",name); 
      return -1; 
   
   } 
     
   SymbolAddChild(phsleParent,phsleChild);
   


   NeurospacesAddSymbol(pcChild, iChild);
   //NeurospacesPrintSymbols();

   SymbolRecalcAllSerials(phsleParent, ppistParent);    


   return 1;

}







