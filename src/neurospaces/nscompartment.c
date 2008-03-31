//------------------------------------------------------------------
/*!
 *  \file nscompartment.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for creating compartments
 *  and other data members in the Neurospaces Model Container via
 *  direct calls to the Neurospaces API.
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




/************************************************
 *
 * CreateNeurospacesElement: Creates a "segment" which
 * coorresponds to the GENESIS compartment.
 *
 *
 ***********************************************/
int CreateNeurospacesCompartment(char* name, Element* pelParent, Action* action,int index){

  struct symtab_Segment* psegment = NULL;
  char* pathname = NULL;
  struct PidinStack* ppist = NULL;
  struct symtab_HSolveListElement* phsle = NULL;
  struct symtab_IdentifierIndex* pidin;

  struct nsintegrator_type *pelnsintegrator
    = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  struct neurospaces_integrator *pnsintegrator
    = pelnsintegrator->pnsintegrator;

  struct neurospaces_type *pelNeurospaces = pnsintegrator->pelNeurospaces;

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







