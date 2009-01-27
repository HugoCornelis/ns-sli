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


 
#include "neurospaces/symbols.h"  
#include "neurospaces/symboltable.h"  
#include "neurospaces/pidinstack.h"


//t includes from our nsgenesis library
#include "neurospaces/nsintegrator.h"




//-- prototypes for setting up a basic channel object --
static struct symtab_HSolveListElement * GenChannelCalloc();
static struct symtab_GateKinetic *CreateGateKinetic(char *pcDirection);
struct symtab_HSolveListElement * CreateHHGate(
		 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName);
static struct symtab_ConcentrationGateKinetic *CreateConcGateKinetic(char *pcDirection);
static struct symtab_HSolveListElement * NernstCalloc();
static struct symtab_HSolveListElement * SynChannelCalloc();

//--------------------------------------------------------------------
/*!
 *  \fn int NSCreate( char* name,  char* pcParent, char* pcType)
 *  \param name
 *  \param pcParent
 *  \param pcType
 *  \return 0 on error, 1 on success.
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

     phsleChild = (struct symtab_HSolveListElement*)NernstCalloc();

     iResult = NSINTEGRATOR_NERNST;

   }
   else if(!strcmp("synchan",pcType)){

     phsleChild = (struct symtab_HSolveListElement*)SynChannelCalloc();

     iResult = NSINTEGRATOR_SYNCHAN;

   }
   else if(!strcmp("asc_file",pcType)){

     iResult = NSINTEGRATOR_ASCFILE;

   }
   else if(!strcmp("asc_out",pcType)){

     iResult = NSINTEGRATOR_ASCOUT;

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
 *  \fn static struct symtab_HSolveListElement * GenChannelCalloc()
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






//--------------------------------------------------------------------
/*!
 *  \fn static struct symtab_HSolveListElement * SynChannelCalloc()
 *  \return A pointer to a newly allocated channel object.
 *
 *  
 */
//--------------------------------------------------------------------
static struct symtab_HSolveListElement * SynChannelCalloc(){


  struct symtab_HSolveListElement *phsleChannel = 
    (struct symtab_HSolveListElement*)ChannelCalloc();


  setParameter(phsleChannel,"CHANNEL_TYPE","ChannelSynchan",0);
  

  struct symtab_IdentifierIndex *pidinChannel;


  return phsleChannel;


}




//------------------------------------------------------------------
/*!
 *  \fn struct symtab_HSolveListElemen *CreateHHGate(
                 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName)
 *  \param phsleChannel Pointer to the Channel to attach gates.
 *  \param pcName A name for the HH gate.
 *  \return A pointer to an HSolveListElement which had been appended to phsleChannel
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
 *  \fn struct symtab_HSolveListElement *CreateConcGate(
                 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName)
 *  \param phsleChannel Pointer to the Channel to attach gates.
 *  \param pcName  A name for the concentration gate.
 *  \return A pointer to an HSolveListElement which had been appended to phsleChannel
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
 * \fn static struct symtab_GateKinetic *CreateGateKinetic(char *pcDirection)
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
 * \fn static struct symtab_GateKinetic *CreateConcGateKinetic(char *pcDirection)
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
/*
 */
//---------------------------------------------------------------------
static struct symtab_HSolveListElement * NernstCalloc()
{

  struct symtab_HSolveListElement *phsle = GroupCalloc();

  if(!phsle)
    return NULL;

  
  //  setParameter(phsle,"NSSLI_GROUP","NERNST",SETPARA_STRING);


  struct symtab_Parameters *ppar = ParameterCalloc();    

  ParameterSetName(ppar,"Erev");

  ppar->pparFirst = ppar;


  //! allocate function and function parameters.
  struct symtab_Function *pfun = FunctionCalloc();
  
  FunctionSetName(pfun,"NERNST");


  struct PidinStack *ppistCIn = PidinStackParse(".->Cin");
  struct symtab_IdentifierIndex *pidinCIn = PidinStackToPidinQueue(ppistCIn);
  
  struct symtab_Parameters *pparCIn = 
    ParameterNewFromPidinQueue("Cin",pidinCIn,TYPE_PARA_FIELD); 



  struct PidinStack *ppistCOut = PidinStackParse(".->Cout");
  struct symtab_IdentifierIndex *pidinCOut = PidinStackToPidinQueue(ppistCOut);

  struct symtab_Parameters *pparCOut = 
    ParameterNewFromPidinQueue("Cout",pidinCOut,TYPE_PARA_FIELD);


  struct PidinStack *ppistValency = PidinStackParse(".->valency");
  struct symtab_IdentifierIndex *pidinValency = PidinStackToPidinQueue(ppistValency);

  struct symtab_Parameters *pparValency = 
    ParameterNewFromPidinQueue("valency",pidinValency,TYPE_PARA_FIELD);


  struct PidinStack *ppistT = PidinStackParse(".->T");
  struct symtab_IdentifierIndex *pidinT = PidinStackToPidinQueue(ppistT);

  struct symtab_Parameters *pparT = 
    ParameterNewFromPidinQueue("T",pidinT,TYPE_PARA_FIELD);



  pparCIn->pparFirst = pparCIn;
  pparCIn->pparNext = pparCOut;

  pparCOut->pparFirst = pparCIn;
  pparCOut->pparNext = pparValency;
  
  pparValency->pparFirst = pparCIn;
  pparValency->pparNext = pparT;

  pparT->pparFirst = pparCIn;
  pparT->pparNext = NULL;

  FunctionAssignParameters(pfun,pparCIn);


  
  ppar->uValue.pfun = pfun;


  ParameterSetType(ppar,TYPE_PARA_FUNCTION);



  BioComponentChangeParameter((struct symtab_BioComponent *)phsle,ppar);
  return phsle;

}
