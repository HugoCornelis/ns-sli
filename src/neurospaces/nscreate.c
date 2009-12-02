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


 
#include "neurospaces/components/attachment.h"
#include "neurospaces/components/cell.h"
#include "neurospaces/components/channel.h"
#include "neurospaces/components/pool.h"
#include "neurospaces/components/segment.h"
#include "neurospaces/function.h"
#include "neurospaces/symbols.h"  
#include "neurospaces/symboltable.h"  
#include "neurospaces/pidinstack.h"
#include "neurospaces/idin.h"


//t includes from our nsgenesis library
#include "neurospaces/nsintegrator.h"




//-- prototypes for setting up a basic channel object --
static struct symtab_HSolveListElement * NernstCalloc();
static struct symtab_HSolveListElement * SynChannelCalloc();

//--------------------------------------------------------------------
/*!
 *  \fn int NSCreate( char* name,  char* pcParent, char* pcType)
 *
 *  \param name
 *  \param pcParent
 *  \param pcType
 *
 *  \return -1 on error, 1 for root element, a NSINTEGRATOR_* define
 *  otherwise.
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


   struct g2_g3_element_mapper
   {
       char *pcG2;
       int iG3;
   };

   struct g2_g3_element_mapper pggem[] =
   {
       "compartment", NSINTEGRATOR_COMPARTMENT,
       "symcompartment", NSINTEGRATOR_COMPARTMENT,
       "tabchannel", NSINTEGRATOR_TABCHANNEL,
       "Ca_concen", NSINTEGRATOR_POOL,
       "nernst",  NSINTEGRATOR_NERNST,
       "synchan", NSINTEGRATOR_SYNCHAN,
       "channelC2", NSINTEGRATOR_SYNCHAN,
       "channelC3", NSINTEGRATOR_SYNCHAN,
       "spikegen", NSINTEGRATOR_SPIKEGEN,
       "asc_file", NSINTEGRATOR_ASCFILE,
       "pulsegen", NSINTEGRATOR_PULSEGEN,
       (char *)-1, NSINTEGRATOR_NEUTRAL,
       NULL, NULL,
   };


   if(strcmp("compartment",pcType) == 0
      || strcmp("symcompartment", pcType) == 0)
   {
     phsleChild = (struct symtab_HSolveListElement *)SegmentCalloc();

     iResult = NSINTEGRATOR_COMPARTMENT;

     char *pcHeccerName = getRootedPathname(pcParent);

     AttemptHeccerName(pcHeccerName);

     free(pcHeccerName);
   }
   else if(!strcmp("tabchannel",pcType)){

     phsleChild = (struct symtab_HSolveListElement *)ChannelCalloc();

     iResult = NSINTEGRATOR_TABCHANNEL;
   }
   else if(!strcmp("Ca_concen",pcType)){

     //! create a calcium pool
     phsleChild = (struct symtab_HSolveListElement *)PoolCalloc();

     iResult = NSINTEGRATOR_POOL;
     
   }
   else if(!strcmp("nernst",pcType)){

     phsleChild = NernstCalloc();

     iResult = NSINTEGRATOR_NERNST;

   }
   else if(strcmp("synchan",pcType) == 0
	   || strcmp("channelC2",pcType) == 0
	   || strcmp("channelC3",pcType) == 0){

     phsleChild = SynChannelCalloc();

     iResult = NSINTEGRATOR_SYNCHAN;

   }
   else if(strcmp("spikegen",pcType) == 0){

       phsleChild
	   = (struct symtab_HSolveListElement *)AttachmentCalloc();

     AttachmentSetType((struct symtab_Attachment *)phsleChild, TYPE_ATTACHMENT_OUTGOING);

     iResult = NSINTEGRATOR_SPIKEGEN;

   }
   else if(!strcmp("asc_file",pcType)){

     iResult = NSINTEGRATOR_ASCFILE;

   }
/*    else if(!strcmp("asc_out",pcType)){ */

/*      iResult = NSINTEGRATOR_ASCOUT; */

/*    } */

   else if(!strcmp("pulsegen",pcType)){

     // This is temporary until I finish the model container object.

     phsleChild = (struct symtab_HSolveListElement *)CellCalloc();
     
     iResult = NSINTEGRATOR_PULSEGEN;

   }
   else{

       // neutral, hsolve

       phsleChild = (struct symtab_HSolveListElement *)CellCalloc();

       iResult = NSINTEGRATOR_NEUTRAL;
   }
   
   

   if( !phsleChild ){

       Error();
     fprintf(stderr,"Error allocating phsleChild for:%s\n",name);
     return -1;

   }


   char *pcChild = strdup(name);
   pidinChild = IdinNewFromChars(pcChild);
   SymbolSetName(phsleChild, pidinChild); 
   

   //i
   //i Retrieves the parent pathname from
   //i the argument or from an Element in the GENESIS
   //i namespace.
   //i needed in cases where model container objects
   //i are rooted in neutral objects that also reside in the GENESIS
   //i namespace.
   //i ex: /neutral/compartment
   //i

   ppistParent = getRootedContext(pcParent);

/*    if(!strcmp(pcParent,".")) */
/*      ppistParent = PidinStackParse("/"); */
/*    else */
/*      ppistParent = PidinStackParse(pcParent); */
  

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


   PidinStackFree(ppistParent);

   return iResult;

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


  struct symtab_EquationExponential *peq = 
    (struct symtab_EquationExponential *)EquationExponentialCalloc();
  


  struct symtab_IdentifierIndex *pidinEq = 
    (struct symtab_IdentifierIndex *)IdinNewFromChars("eq2");

  if(!pidinEq)
    return NULL;


  SymbolSetName((struct symtab_HSolveListElement*)peq,pidinEq);


  SymbolAddChild((struct symtab_HSolveListElement*)phsleChannel,
		 (struct symtab_HSolveListElement*)peq);

  
  struct symtab_Attachment *patta = AttachmentCalloc();

  AttachmentSetType(patta, TYPE_ATTACHMENT_INCOMING);

  AttachmentSetDataType(patta,"null data"); 


  struct symtab_IdentifierIndex *pidinAct = 
    IdinNewFromChars("synapse");

  if(!pidinAct)
    return NULL;

  SymbolSetName((struct symtab_HSolveListElement*)patta,pidinAct);


  SymbolAddChild((struct symtab_HSolveListElement*)phsleChannel,
		 (struct symtab_HSolveListElement*)patta); 


  //-
  //- 
  //- 

/*   struct PidinStack *ppistZ = PidinStackParse("..->z"); */
/*   struct symtab_IdentifierIndex *pidinZ = PidinStackToPidinQueue(ppistZ); */
  
/*   struct symtab_Parameters *pparZ =  */
/*     ParameterNewFromPidinQueue("activation",pidinZ,TYPE_PARA_FIELD);  */




  struct PidinStack *ppistTau2 = PidinStackParse("..->TAU2");
  struct symtab_IdentifierIndex *pidinTau2 = PidinStackToPidinQueue(ppistTau2);
  
  struct symtab_Parameters *pparTau2 = 
    ParameterNewFromPidinQueue("TAU2",pidinTau2,TYPE_PARA_FIELD); 


  
  struct PidinStack *ppistTau1 = PidinStackParse("..->TAU1");
  struct symtab_IdentifierIndex *pidinTau1 = PidinStackToPidinQueue(ppistTau1);
  
  struct symtab_Parameters *pparTau1 = 
    ParameterNewFromPidinQueue("TAU1",pidinTau1,TYPE_PARA_FIELD); 


  //  pparZ->pparFirst = pparZ;
  //pparZ->pparNext = pparTau1;

  pparTau1->pparFirst = pparTau1;
  pparTau1->pparNext = pparTau2;

  pparTau2->pparFirst = pparTau1;
  pparTau2->pparNext = NULL;


  SymbolAssignParameters((struct symtab_HSolveListElement*)peq,pparTau1);



  return phsleChannel;

}












//---------------------------------------------------------------------
/*
 */
//---------------------------------------------------------------------
static struct symtab_HSolveListElement * NernstCalloc()
{

  struct symtab_HSolveListElement *phsle = (struct symtab_HSolveListElement *)GroupCalloc();

  if(!phsle)
    return NULL;

  
  //  setParameter(phsle,"NSSLI_GROUP","NERNST",SETPARA_STRING);


  struct symtab_Parameters *ppar = ParameterCalloc();    

  ParameterSetName(ppar,"Erev");

  ppar->pparFirst = ppar;


  //i allocate function and function parameters.
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
