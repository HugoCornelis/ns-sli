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


#define FORWARD 1
#define BACKWARD -1

//-- prototypes for setting up a basic channel object --
static struct symtab_HSolveListElement * GenChannelCalloc();
static struct symtab_GateKinetic *CreateGateKinetic(int iDirection);



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

//--------------------------------------------------------------------
int NSCreate( char* name,  char* pcParent, char* pcType){

   struct symtab_HSolveListElement *phsleChild = NULL;
   struct PidinStack* ppistParent = NULL;
   struct symtab_HSolveListElement* phsleParent = NULL;
   struct symtab_IdentifierIndex* pidinChild;
   int iResult;

   //- if there is no parent given

   if (!pcParent || !strcmp(pcParent,""))
     {
       //- assume we are creating a root element on initialization.

       //! normally genesis creates an element without parent for default values,
       //! and a second element without parent for the root element

       return 1;
     }


   if(!strcmp("compartment",pcType)){

     phsleChild = (struct symtab_HSolveListElement*)SegmentCalloc();

     iResult = NSINTEGRATOR_COMPARTMENT;

   }
   else if(!strcmp("tabchannel",pcType)){

     phsleChild = (struct symtab_HSolveListElement*)GenChannelCalloc();

     iResult = NSINTEGRATOR_TABCHANNEL;
   }
   else{

     phsleChild = (struct symtab_HSolveListElement*)CellCalloc();

     iResult = NSINTEGRATOR_NEUTRAL;

   }
   
   

   if( !phsleChild ){

     fprintf(stderr,"Error allocating phsleChild for:%s\n",name);
     return -1;

   }


   char *pcChild = strdup(name);
   pidinChild = IdinNewFromChars(pcChild);
   SymbolSetName(phsleChild, pidinChild); 
   

   //!
   //! Retrieves the parent pathname from
   //! the argument or from an Element in the GENESIS
   //! namespace.
   //! needed in cases where model container objects
   //! are rooted in neutral objects that also reside in the GENESIS
   //! namespace.
   //! ex: /neutral/compartment
   //!

   if(!strcmp(pcParent,"."))
     ppistParent = PidinStackParse("/");
   else
     ppistParent = PidinStackParse(pcParent);
  

   if( !ppistParent ){

     fprintf(stderr,"Error creating symbol: %s\n", name);
     return -1;
   
   }
  
   phsleParent = PidinStackLookupTopSymbol(ppistParent);  
   
   if( !phsleParent ){ 

      fprintf(stderr,"Error:Symbol parent path (%s) not found\n",pcParent); 
      return -1; 
   
   } 
     
   SymbolAddChild(phsleParent,phsleChild);
   

   SymbolRecalcAllSerials(phsleParent, ppistParent);    


   return iResult;

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


  struct symtab_HSolveListElement *phsleChannel = 
    (struct symtab_HSolveListElement*)ChannelCalloc();


  setParameter(phsleChannel,"CHANNEL_TYPE","ChannelAct",0);
  

  struct symtab_IdentifierIndex *pidinChannel;

  pidinChannel =  IdinNewFromChars("Channel");
  
  SymbolSetName(phsleChannel,pidinChannel);



  //!
  //! Allocate an HH gate and set its parent to phsleTabChannel.
  //!
  struct symtab_HHGate *pgathh = HHGateCalloc();
  
  setParameter(pgathh,"state_init","0.7612305421",SETPARA_GENESIS2);

  struct symtab_IdentifierIndex *pidinHHGate = 
    IdinNewFromChars("HH_activation");

  SymbolSetName(&pgathh->bio.ioh.iol.hsle,pidinHHGate);

  SymbolAddChild(phsleChannel,&pgathh->bio.ioh.iol.hsle);



  
  //!
  //! Need to add a name for the forward and backward gates.
  //! "Forward" and "Backward" respectively, then make these
  //! the children of the HH Gate pgathh.
  //!
  struct symtab_GateKinetic *pgatkForward = CreateGateKinetic(FORWARD);

  if(!pgatkForward)
    return NULL;

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle,
		 &pgatkForward->bio.ioh.iol.hsle);
  


  struct symtab_GateKinetic *pgatkBackward = CreateGateKinetic(BACKWARD);

  if(!pgatkBackward)
    return NULL;

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle,
		 &pgatkBackward->bio.ioh.iol.hsle);



  return phsleChannel;


}






//------------------------------------------------------------------
/*
 *
 */
//------------------------------------------------------------------
static struct symtab_GateKinetic *CreateGateKinetic(int iDirection){


  struct symtab_GateKinetic *pgatk;


  struct symtab_IdentifierIndex *pidinDirection;

  
  if(iDirection > 0)
    pidinDirection = IdinNewFromChars("forward");
  else
    pidinDirection = IdinNewFromChars("backward");


  if(!pidinDirection)
    return NULL;


  pgatk = GateKineticCalloc();

  if(!pgatk)
    return NULL;


  SymbolSetName(&pgatk->bio.ioh.iol.hsle,pidinDirection);

  return pgatk;

}
