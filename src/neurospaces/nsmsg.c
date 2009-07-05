//------------------------------------------------------------------
/*!
 *  \file nsmsg.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for creating messages in
 *  objects in the Model Container. Currently does not support 
 *     GENESIS <--> model_container 
 *  message passing.
*/
//-------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"

#include "heccer/addressing.h"

#include "neurospaces/symbols.h"  
#include "neurospaces/symboltable.h"  
#include "neurospaces/pidinstack.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/function.h"

//t includes from our nsgenesis library"
#include "nsintegrator.h"



static int AxialMsg(char *pcSrcpath, char *pcDstpath);
static int ChannelMsg( char *pcSrcpath, char *pcDstpath);
static int CalciumPoolMsg(char *pcSrcpath, char *pcDstpath);
static int VoltageMsg(char *pcSrcpath, char *pcDstpath);
static int ConcenMsg(char *pcSrcpath, char *pcDstpath);
static int CinMsg(char *pcSrcpath, char *pcDstpath);
static int EkMsg(char *pcSrcpath, char *pcDstpath);
static int StoreMsg(char *pcSrcpath, char *pcDstpath,char *pcField,char *pcMsgName);

static struct symtab_IOContainer *IOContainerFromList(char *ppcParmaters[], int iType[]);
static struct symtab_IdentifierIndex * PidinQueueLookupTarget(char *pcSrcpath, 
							      char *pcDstpath);


//-------------------------------------------------------------------
/*!
 *   \fn int NSmsg(char *pcSrcpath, char *pcDstpath, char *pcTypename)
 *   \param pcSrcpath The identifier for the Parent HSolve element.
 *   \param pcDstpath The identidier for the Child HSolve element.
 *   \param pcTypename The "message" type to pass to from Parent to child.
 *   \return 0 on error, 1 on success.
 *
 *   Function creates a message between two objects.
 */
//-------------------------------------------------------------------
int NSmsg(char *pcSrcpath, char *pcDstpath, char *pcTypename, char *pcField){


    // model structure messages

  //-
  //- If the user tries to perform a mesage using Reverse Axial 
  //- then we return as success since we're ignoring this case.
  //-
  if(strcmp(pcTypename,"RAXIAL") == 0)
    return 1;


  

  if (strcmp(pcTypename, "AXIAL") == 0)
  {

    return  AxialMsg(pcSrcpath,pcDstpath);

  }
  else if(strcmp(pcTypename,"I_Ca") == 0){

    //!
    //! Create a calcium pool.
    //!

    return CalciumPoolMsg(pcSrcpath, pcDstpath);

  }
  else if (strcmp(pcTypename, "VOLTAGE") == 0){

    return VoltageMsg(pcSrcpath,pcDstpath);

  }
  else if(strcmp(pcTypename,"CHANNEL") == 0){


    return ChannelMsg(pcSrcpath,pcDstpath);

  }
  else if(strcmp(pcTypename,"CONCEN") == 0){

    return ConcenMsg(pcSrcpath,pcDstpath);

  }
  else if(strcmp(pcTypename,"CIN") == 0){

    return CinMsg(pcSrcpath,pcDstpath);

  }
  else if(strcmp(pcTypename,"EK") == 0){

    return EkMsg(pcSrcpath,pcDstpath);

  }


  // input messages

  else if(strcmp(pcTypename,"ACTIVATION") == 0){

    return StoreMsg(pcSrcpath,pcDstpath,pcField,"activation");

  }

  // output messages

  else if(strcmp(pcTypename,"SAVE") == 0){

    return StoreMsg(pcSrcpath,pcDstpath,pcField,"save");
  }



  return 0;
}




//---------------------------------------------------------------
/*!
 *  \fn int AxialMsg(char *pcSrcpath, char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 *
 *  This is done by setting the parameter pcSrcPath as "PARENT" and 
 *  linking this parameter to the phsle instace in pcDstPath via a
 *  reference.
 */
//----------------------------------------------------------------
static int AxialMsg(char *pcSrcpath, char *pcDstpath)
{


  struct PidinStack *ppistSrc = getRootedContext(pcSrcpath);
  
  struct PidinStack *ppistDst = getRootedContext(pcDstpath);

  struct symtab_HSolveListElement *phsleSrc = PidinStackLookupTopSymbol(ppistSrc);

  struct symtab_HSolveListElement *phsleDst = PidinStackLookupTopSymbol(ppistDst);


  if(!phsleSrc){

    Error();
    printf("source %s of msg is not found in the Model Container.", pcSrcpath);
    return 0;

  }

  if(!phsleDst){ 

    Error(); 
    printf("dest %s of msg is not found in the Model Container.", pcDstpath); 
    return 0; 
    
  } 


  struct symtab_IdentifierIndex *pidinSrc
    = IdinNewFromChars(SymbolGetName(phsleSrc));

  PidinStackFree(ppistSrc);



  struct symtab_IdentifierIndex *pidinThis
    = IdinNewFromChars("..");

  //- link pidins into a queue
  
  //! we assume that AXIAL is the somatofugal direction
  //! while PARENT points to the somatopetal direction
  //!
  //! that is why here we reverse the direction

  pidinSrc->pidinRoot = pidinThis;
  pidinThis->pidinRoot = pidinThis;

  pidinThis->pidinNext = pidinSrc;

  //h
  //h Here we prepare a function pointer and parameter
  //h for the parent HSolve element to label it a
  //h PARENT element.
  //h

  struct symtab_Parameters *ppar
    = ParameterNewFromPidinQueue("PARENT", pidinThis, TYPE_PARA_SYMBOLIC);


  BioComponentChangeParameter(
			      (struct symtab_BioComponent *)phsleDst, ppar);

  return 1;


}





//----------------------------------------------------------------------------
/*!
 *  \fn int ChannelMsg(char *pcSrcpath, char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.

 *  Creates a message between channels by way of bindables and bindings. 
 */
//----------------------------------------------------------------------------
static int ChannelMsg(char *pcSrcpath,char *pcDstpath)
{

  struct PidinStack *ppistSrc = getRootedContext(pcSrcpath);
  
  struct PidinStack *ppistDst = getRootedContext(pcDstpath);

  struct symtab_HSolveListElement *phsleSrc = PidinStackLookupTopSymbol(ppistSrc);

  struct symtab_HSolveListElement *phsleDst = PidinStackLookupTopSymbol(ppistDst);


  //!
  //! recaculate all serials before performing a pidinstack subtract
  //!
  struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  SymbolRecalcAllSerials(pelnsintegrator->pnsintegrator->phsleCachedRoot, 
                         pelnsintegrator->pnsintegrator->ppistCachedRoot);

  
  struct PidinStack *ppistTarget = PidinStackSubtract(ppistSrc,ppistDst);


  if(!ppistTarget)
  {

    fprintf(stderr,"Error adding message from %s to %s\n",pcSrcpath,pcDstpath);
    return -1;
    
  }




  //- bind I/O relations

  char pcTarget[100];
  

  PidinStackString(ppistTarget,pcTarget,sizeof(pcTarget));


  int iLen = strlen(pcTarget);

  strcpy(&pcTarget[iLen],"->I");



  struct symtab_InputOutput *pio =  CreateInputOutput(pcTarget,INPUT_TYPE_INPUT);

  SymbolAssignInputs(phsleDst, pio);

  PidinStackFree(ppistSrc);
  PidinStackFree(ppistDst);
  PidinStackFree(ppistTarget);

  return 1;

}




//----------------------------------------------------------------------------
/*!
 *  \fn static int CalciumPoolMsg(char *pcSrcpath, char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 *
 *  Creates a message for a calcium pool via bindings and bindables.
 */
//----------------------------------------------------------------------------
static int CalciumPoolMsg(char *pcSrcpath, char *pcDstpath)
{


  struct PidinStack *ppistSrc = getRootedContext(pcSrcpath);
  
  struct PidinStack *ppistDst = getRootedContext(pcDstpath);


  struct symtab_HSolveListElement *phsleSrc = PidinStackLookupTopSymbol(ppistSrc);

  struct symtab_HSolveListElement *phsleDst = PidinStackLookupTopSymbol(ppistDst);


  //!
  //! recaculate all serials before performing a pidinstack subtract
  //!
  struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  SymbolRecalcAllSerials(pelnsintegrator->pnsintegrator->phsleCachedRoot, 
                         pelnsintegrator->pnsintegrator->ppistCachedRoot);

  
  struct PidinStack *ppistTarget = PidinStackSubtract(ppistSrc,ppistDst);


  if(!ppistTarget)
  {

    fprintf(stderr,"Error adding message from %s to %s\n",pcSrcpath,pcDstpath);
    return -1;
    
  }


  //- bind I/O relations

  char pcTarget[100];
  

  PidinStackString(ppistTarget,pcTarget,sizeof(pcTarget));




  //!
  //! Put these lines back in when pindinstack parse properly accounts for the 'I' at
  //! the end.
  //!
  //  int iLen = strlen(pcTarget);
  //
  //strcpy(&pcTarget[iLen],"->I");
  // struct symtab_InputOutput *pio =  CreateInputOutput(pcTarget,INPUT_TYPE_INPUT);


  //!
  //! this code will tack on 'I' to the end of the idin queue and 
  //! flag it as a binding.
  //!
  //! ----------------------------------------------------------------
  struct PidinStack *ppist = PidinStackParse(pcTarget);

  struct symtab_IdentifierIndex *idinTarget = PidinStackToPidinQueue(ppist);
  
  
  //! create 'I'
  struct symtab_IdentifierIndex *idinI = IdinNewFromChars("I");


  idinI->pidinRoot = idinTarget;
  idinI->iFlags = FLAG_IDENTINDEX_FIELD;

  struct symtab_IdentifierIndex *idin;
  for(idin = idinTarget; idin->pidinNext ;idin = idin->pidinNext);
  
  idin->pidinNext = idinI;


  struct symtab_InputOutput *pio = InputOutputNewForType(INPUT_TYPE_INPUT);

  if(!pio)
  {
    return 0;
  }


  pio->pidinField = idinTarget;

  //! ---------------- end inserted code ------------------------------

  SymbolAssignInputs(phsleDst, pio);

  PidinStackFree(ppistSrc);
  PidinStackFree(ppistDst);
  PidinStackFree(ppistTarget);

  PidinStackFree(ppist);

  return 1;

}



//----------------------------------------------------------------------------
/*!
 *  \fn static int VoltageMsg(char *pcSrcpath, char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 *
 *  Creates A voltage message by way of a "Vm" binding for input.
 *  
 */
//----------------------------------------------------------------------------
static int VoltageMsg(char *pcSrcpath, char *pcDstpath)
{

  struct PidinStack *ppistSrc = getRootedContext(pcSrcpath);
  
  struct PidinStack *ppistDst = getRootedContext(pcDstpath);


  struct symtab_HSolveListElement *phsleSrc = PidinStackLookupTopSymbol(ppistSrc);

  struct symtab_HSolveListElement *phsleDst = PidinStackLookupTopSymbol(ppistDst);


  //!
  //! recaculate all serials before performing a pidinstack subtract
  //!
  struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  SymbolRecalcAllSerials(pelnsintegrator->pnsintegrator->phsleCachedRoot, 
                         pelnsintegrator->pnsintegrator->ppistCachedRoot);

  
  struct PidinStack *ppistTarget = PidinStackSubtract(ppistSrc,ppistDst);


  if(!ppistTarget)
  {

    fprintf(stderr,"Error adding message from %s to %s\n",pcSrcpath,pcDstpath);
    return -1;
    
  }


  //- bind I/O relations

  char pcTarget[100];
  

  PidinStackString(ppistTarget,pcTarget,sizeof(pcTarget));


  int iLen = strlen(pcTarget);

  strcpy(&pcTarget[iLen],"->Vm");


  struct symtab_InputOutput *pio =  CreateInputOutput(pcTarget,INPUT_TYPE_INPUT);

  SymbolAssignInputs(phsleDst, pio);

  PidinStackFree(ppistSrc);
  PidinStackFree(ppistDst);
  PidinStackFree(ppistTarget);


  return 1;
  
}






//----------------------------------------------------------------------------
/*!
 *  \fn static int ConcenMsg(char *pcSrcpath, char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 *
 *  Creates a concentration message by linking to the "concen" parameter
 *  in the destination element.
 */
//----------------------------------------------------------------------------
static int ConcenMsg(char *pcSrcpath, char *pcDstpath)
{


  struct PidinStack *ppistSrc = getRootedContext(pcSrcpath);
  
  struct PidinStack *ppistDst = getRootedContext(pcDstpath);


  struct symtab_HSolveListElement *phsleSrc = PidinStackLookupTopSymbol(ppistSrc);

  struct symtab_HSolveListElement *phsleDst = PidinStackLookupTopSymbol(ppistDst);


  //!
  //! recaculate all serials before performing a pidinstack subtract
  //!
  struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  SymbolRecalcAllSerials(pelnsintegrator->pnsintegrator->phsleCachedRoot, 
                         pelnsintegrator->pnsintegrator->ppistCachedRoot);

  
  struct PidinStack *ppistTarget = PidinStackSubtract(ppistSrc,ppistDst);


  if(!ppistTarget)
  {

    fprintf(stderr,"Error adding message from %s to %s\n",pcSrcpath,pcDstpath);
    return -1;
    
  }


  //- bind I/O relations

  char pcTarget[100];
  

  PidinStackString(ppistTarget,pcTarget,sizeof(pcTarget));




  //!
  //! Put these lines back in when pindinstack parse properly accounts for the 'I' at
  //! the end.
  //!
    int iLen = strlen(pcTarget);
  //
  strcpy(&pcTarget[iLen],"->concen");
  struct symtab_InputOutput *pio =  CreateInputOutput(pcTarget,INPUT_TYPE_INPUT);



  //! ---------------- end inserted code ------------------------------

  SymbolAssignInputs(phsleDst, pio);


  PidinStackFree(ppistSrc);
  PidinStackFree(ppistDst);
  PidinStackFree(ppistTarget);


  return 1;


}




//-------------------------------------------------------------------------
/*!
 *  \fn static int CinMsg(char *pcSrcpath, char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 *
 *  Creates a Cin message via two parameter setting. A reference to a local
 *  concen_init parameter, which references a concen_init parameter that is 
 *  in a pool. 
 */
//-------------------------------------------------------------------------
static int CinMsg(char *pcSrcpath, char *pcDstpath)
{


  struct PidinStack *ppistSrc = getRootedContext(pcSrcpath);
  
  struct PidinStack *ppistDst = getRootedContext(pcDstpath);


  struct symtab_HSolveListElement *phsleSrc = PidinStackLookupTopSymbol(ppistSrc);

  struct symtab_HSolveListElement *phsleDst = PidinStackLookupTopSymbol(ppistDst);


  //!
  //! recaculate all serials before performing a pidinstack subtract
  //!
  struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  SymbolRecalcAllSerials(pelnsintegrator->pnsintegrator->phsleCachedRoot, 
                         pelnsintegrator->pnsintegrator->ppistCachedRoot);

  
  struct PidinStack *ppistTarget = PidinStackSubtract(ppistSrc,ppistDst);


  if(!ppistTarget)
  {

    fprintf(stderr,"Error adding message from %s to %s\n",pcSrcpath,pcDstpath);
    return -1;
    
  }


  char pcTarget[100];


  setParameter(ppistSrc, phsleSrc,"Cin",".->concen_init",SETPARA_FIELD);
  

  PidinStackString(ppistTarget,pcTarget,sizeof(pcTarget));

  int iLen = strlen(pcTarget);

  strcpy(&pcTarget[iLen],"->Cin");


  int iResult = setParameter(ppistDst, phsleDst,"Cin",pcTarget,SETPARA_FIELD);

  if(!iResult)
  {

    fprintf(stderr,"Error adding message from %s to %s\n",pcSrcpath,pcDstpath);
    return -1;
    
  }

  PidinStackFree(ppistSrc);
  PidinStackFree(ppistDst);
  PidinStackFree(ppistTarget);


  return 1;

}




//-------------------------------------------------------------------------
/*!
 *  \fn static int EkMsg(char *pcSrcpath, char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 */
//-------------------------------------------------------------------------
static int EkMsg(char *pcSrcpath, char *pcDstpath)
{


  struct PidinStack *ppistSrc = getRootedContext(pcSrcpath);
  
  struct PidinStack *ppistDst = getRootedContext(pcDstpath);


  struct symtab_HSolveListElement *phsleSrc = PidinStackLookupTopSymbol(ppistSrc);

  struct symtab_HSolveListElement *phsleDst = PidinStackLookupTopSymbol(ppistDst);


  //!
  //! recaculate all serials before performing a pidinstack subtract
  //!
  struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  SymbolRecalcAllSerials(pelnsintegrator->pnsintegrator->phsleCachedRoot, 
                         pelnsintegrator->pnsintegrator->ppistCachedRoot);

  
  struct PidinStack *ppistTarget = PidinStackSubtract(ppistSrc,ppistDst);



  if(!ppistTarget)
  {

    fprintf(stderr,"Error adding message from %s to %s\n",pcSrcpath,pcDstpath);
    return -1;
    
  }


  char pcTarget[100];
  

  PidinStackString(ppistTarget,pcTarget,sizeof(pcTarget));


  int iLen = strlen(pcTarget);

  strcpy(&pcTarget[iLen],"->Erev");


  int iResult = setParameter(ppistDst, phsleDst,"Erev",pcTarget,SETPARA_FIELD);

  if(!iResult)
  {

    fprintf(stderr,"Error adding message from %s to %s\n",pcSrcpath,pcDstpath);
    return -1;
    
  }

  PidinStackFree(ppistSrc);
  PidinStackFree(ppistDst);
  PidinStackFree(ppistTarget);


  return 1;

}






static int StoreMsg(char *pcSrcpath, 
		  char *pcDstpath, 
		  char *pcField,
		  char *pcMsgName){


    //- do hsolve correction for fields

    if (undo_findsolvefield(&pcSrcpath, &pcField))
    {
    }
    else
    {
	pcSrcpath = strdup(pcSrcpath);

	pcField = strdup(pcField);
    }

    // \todo not sure if this should be getRootedContext() or not.

/*    struct PidinStack *ppistSrc = PidinStackParse(pcSrcpath);   */

   struct PidinStack *ppistSrc = getRootedContext(pcSrcpath);  

/*    PidinStackUpdateCaches(ppistSrc);  */

   struct symtab_HSolveListElement *phsle =  
     PidinStackLookupTopSymbol(ppistSrc); 

   if(!phsle)
   {
     char pc[100];

     PidinStackString(ppistSrc,&pc[0],100);

     fprintf(stderr,
	     "Error creating message for %s: Symbol not found.\n",
	     pc);

     // \todo should return zero overhere?

     return -1;
   }

   struct neurospaces_integrator *pnsintegrator =
     getNsintegrator();

   

   struct ioMsg *piom =
      (struct ioMsg*)calloc(1,sizeof(struct ioMsg));

   piom->pcTargetSymbol = strdup(pcDstpath);

   piom->pcSourceField = strdup(pcField);

   piom->pcSourceSymbol = strdup(pcSrcpath);

   piom->iSerial = INT_MAX;

   piom->pcMsgName = strdup(pcMsgName);

   //   piom->dValue = FLT_MAX;

   pnsintegrator->ppioMsg[pnsintegrator->iIoMsgs++] = piom;

   //- free allocated memory

   free(pcSrcpath);

   free(pcField);

   //- return success

   return 1;

};









/*!
 * \fn int NSProcessMessages(struct neurospaces_integrator *pnsintegrator)
 * \param pnsintegrator A pointer to the neurospace integrator struct.
 * \return -1 on error, 1 on success.
 *
 */
int NSProcessMessages(struct neurospaces_integrator *pnsintegrator)
{

  int i;

  struct ioMsg **ppioMsg = pnsintegrator->ppioMsg;

  struct Heccer **ppheccer = pnsintegrator->ppheccer;

  if(!ppioMsg)
    return -1;

  for (i = 0 ; i < pnsintegrator->iIoMsgs ; i++) 
  {

    if(!strcmp(ppioMsg[i]->pcMsgName,"save"))
      continue;
      

    if(ppioMsg[i]->pcSourceSymbol)
    {

      //- resolve source

      struct PidinStack *ppistSource
	= PidinStackParse(ppioMsg[i]->pcSourceSymbol);

      struct symtab_HSolveListElement *phsleSource
	= PidinStackLookupTopSymbol(ppistSource);

      //- fetch value

      ppioMsg[i]->dValue
	= SymbolParameterResolveValue(phsleSource, ppistSource, ppioMsg[i]->pcSourceField);

      if (ppioMsg[i]->dValue != FLT_MAX)
      {
	  //- resolve target

	  struct PidinStack *ppistTarget
	      = PidinStackParse(ppioMsg[i]->pcTargetSymbol);

	  PidinStackUpdateCaches(ppistTarget);


	  int iTarget;

	  if (ppioMsg[i]->iSerial == INT_MAX)
	  {
	      iTarget = PidinStackToSerial(ppistTarget);
	      ppioMsg[i]->iSerial = iTarget;
	  }
	  else
	      iTarget = ppioMsg[i]->iSerial;


      
	  double *pdValue
	      = HeccerAddressVariable(ppheccer[0], iTarget, ppioMsg[i]->pcMsgName);

	  if (pdValue)
	  {
	      if (!strcmp(ppioMsg[i]->pcMsgName,"activation"))
	      {
		  //- add source to target

		  *pdValue += ppioMsg[i]->dValue * clock_value[0];
	      }
	      else
	      {
		  Error();

		  fprintf(stderr,
			  "Error accessing numeric field %s, only activation is supported.\n",
			  ppioMsg[i]->pcSourceField);

		  return -1;
	      }
	  }
	  else
	  {
	      Error();

	      fprintf(stderr,
		      "Error processing message from %s to %s, %s field not found in heccer.\n",
		      ppioMsg[i]->pcSourceField, ppioMsg[i]->pcMsgName, ppioMsg[i]->pcMsgName);

	      return -1;
	  }
      }
      else
      {
	  Error();

	  fprintf(stderr,
		  "Error accessing numeric field %s.\n",
		  ppioMsg[i]->pcSourceField);
	  
      }
    }

  }

  return 1;

}

