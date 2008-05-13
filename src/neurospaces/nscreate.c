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


//-- prototype for setting up a basic tabchannel object --
static struct symtab_HSolveListElement * GenChannelCalloc();




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

   case NSINTEGRATOR_TABCHANNEL:
     phsleChild = (struct symtab_HSolveListElement*)GenChannelCalloc();
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
   

   SymbolRecalcAllSerials(phsleParent, ppistParent);    


   return 1;

}



//--------------------------------------------------------------------
/*!
 *  \fun static struct symtab_HSolveListElement * GenChannelCalloc()
 *  \return A pointer to a newly allocated Tab channel object.
 *
 *  
 */
//--------------------------------------------------------------------
static struct symtab_HSolveListElement * GenChannelCalloc(){


  struct symtab_HSolveListElement *phsleTabChannel = 
    (struct symtab_HSolveListElement*)ChannelCalloc();



  //-
  //- Allocate an HH gate and set its parent to phsleTabChannel.
  //-
  struct symtab_IdentifierIndex* pidinTabChannel;

  struct symtab_HHGate *pgathh = HHGateCalloc();
  
  SymbolAddChild(phsleTabChannel,pgathh);



  
  //-
  //- Need to add a name for the forward and backward gates.
  //- "Forward" and "Backward" respectively, then make these
  //- the children of the HH Gate pgathh.
  //-
  struct symtab_GateKinetic *pgatkForward = GateKineticCalloc();

  if(!pgatkForward)
    return NULL;

  struct symtab_IdentifierIndex * pidinForward;

  pidinForward = IdinNewFromChars("Forward");

  SymbolSetName(pgatkForward, pidinForward); 

  SymbolAddChild(pgathh,pgatkForward);




  struct symtab_GateKinetic *pgatkBackward = GateKineticCalloc();

  if(!pgatkBackward)
    return NULL;


  struct symtab_IdentifierIndex * pidinBackward;

  pidinBackward = IdinNewFromChars("Backward");

  SymbolSetName(pgatkBackward,pidinBackward);

  SymbolAddChild(pgathh,pgatkBackward);


  return phsleTabChannel;
}


