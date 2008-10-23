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
#include "neurospaces/concentrationgatekinetic.h"

//t includes from our nsgenesis library
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/nsintegrator.h"




//-- prototypes for setting up a basic channel object --
static struct symtab_HSolveListElement * GenChannelCalloc();
static struct symtab_GateKinetic *CreateGateKinetic(char *pcDirection);
struct symtab_HSolveListElement * CreateHHGate(
		 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName);
static struct symtab_ConcentrationGateKinetic *CreateConcGateKinetic(char *pcDirection);



//--------------------------------------------------------------------
/*
 *
 */
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
   else if(!strcmp("Ca_concen",pcType)){

     //! create a calcium pool
     phsleChild = (struct symtab_HSolveListElement*)PoolCalloc();

     iResult = NSINTEGRATOR_POOL;
     
   }
   else if(!strcmp("nernst",pcType)){

     phsleChild = (struct symtab_HSolveListElement*)GroupCalloc();

     iResult = NSINTEGRATOR_GROUP;

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


  //setParameter(phsleChannel,"CHANNEL_TYPE","ChannelAct",0);
  

  struct symtab_IdentifierIndex *pidinChannel;


  return phsleChannel;


}







//------------------------------------------------------------------
/*!
 *  \fn int CreateHHGate(struct symtab_HSolveListElement phsleChannel, 
		 char *pcName)
 *  \param phsleChannel Pointer to the Channel to attach gates.
 *  \param pcName
 *
 */
//------------------------------------------------------------------
struct symtab_HSolveListElement * CreateHHGate(
		 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName){


  //!
  //! Allocate an HH gate and set its parent to phsleTabChannel.
  //!
  struct symtab_HHGate *pgathh = HHGateCalloc();


  if(!pgathh)
    return NULL;





  struct symtab_IdentifierIndex *pidinHHGate = 
    IdinNewFromChars(pcName);



  if(!pidinHHGate)
    return NULL;


  SymbolSetName(&pgathh->bio.ioh.iol.hsle,pidinHHGate);

  SymbolAddChild(phsleChannel,&pgathh->bio.ioh.iol.hsle);

  
  //!
  //! Need to add a name for the forward and backward gate kinetics.
  //! "forward" and "backward" respectively, then make these
  //! the children of the HH Gate pgathh.
  //!
  struct symtab_GateKinetic *pgatkForward = 
    CreateGateKinetic("A");

  if(!pgatkForward)
    return NULL;

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle,
		 &pgatkForward->bio.ioh.iol.hsle);
  


  struct symtab_GateKinetic *pgatkBackward = 
    CreateGateKinetic("B");

  if(!pgatkBackward)
    return NULL;

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle,
		 &pgatkBackward->bio.ioh.iol.hsle);


  return (struct symtab_HSolveListElement *)pgathh;

}





//------------------------------------------------------------------
/*!
 *  \fn int CreateConcGate(struct symtab_HSolveListElement phsleChannel, 
		 char *pcName)
 *  \param phsleChannel Pointer to the Channel to attach gates.
 *  \param pcName
 *
 */
//------------------------------------------------------------------
struct symtab_HSolveListElement * CreateConcGate(
		 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName){


  //!
  //! Allocate an HH gate and set its parent to phsleTabChannel.
  //!
  struct symtab_HHGate *pgathh = HHGateCalloc();


  if(!pgathh)
    return NULL;



  struct symtab_IdentifierIndex *pidinHHGate = 
    IdinNewFromChars(pcName);



  if(!pidinHHGate)
    return NULL;


  SymbolSetName(&pgathh->bio.ioh.iol.hsle,pidinHHGate);

  SymbolAddChild(phsleChannel,&pgathh->bio.ioh.iol.hsle);

  
  //!
  //! Need to add a name for the forward and backward gate kinetics.
  //! "forward" and "backward" respectively, then make these
  //! the children of the HH Gate pgathh.
  //!
  struct symtab_ConcentrationGateKinetic *pconcgatkForward = 
    CreateConcGateKinetic("A");

  if(!pconcgatkForward)
    return NULL;

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle,
		 &pconcgatkForward->bio.ioh.iol.hsle);
  


  struct symtab_ConcentrationGateKinetic *pconcgatkBackward = 
    CreateConcGateKinetic("B");

  if(!pconcgatkBackward)
    return NULL;

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle,
		 &pconcgatkBackward->bio.ioh.iol.hsle);


  return (struct symtab_HSolveListElement *)pgathh;

}





//------------------------------------------------------------------
/*
 * \fun static struct symtab_GateKinetic *CreateGateKinetic(char *pcDirection)
 */
//------------------------------------------------------------------
static struct symtab_GateKinetic *CreateGateKinetic(char *pcDirection){


  struct symtab_GateKinetic *pgatk;


  struct symtab_IdentifierIndex *pidinDirection;

  
 
  pidinDirection = IdinNewFromChars(pcDirection);


  if(!pidinDirection)
    return NULL;


  pgatk = GateKineticCalloc();

  if(!pgatk)
    return NULL;


  SymbolSetName(&pgatk->bio.ioh.iol.hsle,pidinDirection);

  return pgatk;

}





//------------------------------------------------------------------
/*
 * \fun static struct symtab_GateKinetic *CreateConcGateKinetic(char *pcDirection)
 */
//------------------------------------------------------------------
static struct symtab_ConcentrationGateKinetic *CreateConcGateKinetic(char *pcDirection){


  struct symtab_ConcentrationGateKinetic *pconcgatk;


  struct symtab_IdentifierIndex *pidinDirection;

  
 
  pidinDirection = IdinNewFromChars(pcDirection);


  if(!pidinDirection)
    return NULL;


  pconcgatk =  ConcentrationGateKineticCalloc();

  if(!pconcgatk)
    return NULL;


  SymbolSetName(&pconcgatk->bio.ioh.iol.hsle,pidinDirection);

  return pconcgatk;

}







//---------------------------------------------------------------------


//---------------------------------------------------------------------
