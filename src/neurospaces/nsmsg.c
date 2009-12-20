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


int iFromTheCellReader = 0;


static int AxialMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName);
static int CalciumPoolMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName);
static int ChannelMsg( char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName);
static int CinMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName);
static int ConcenMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName);
static int EkMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName);
static int StoreMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName);
static int VoltageMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName);


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

    struct g2_g3_message_mapper
    {
	char *pcG2;

	int (*MsgProcess)(char *pcSource, char *pcDestination, char *pcField, char *pcMessage);
    };	

    struct g2_g3_message_mapper pggmm[] =
    {
	"RAXIAL", (int (*)(char *pcSource, char *pcDestination, char *pcField, char *pcMessage))1,
	"AXIAL", AxialMsg,
	"I_Ca", CalciumPoolMsg,
	"VOLTAGE", VoltageMsg,
	"CHANNEL", ChannelMsg,
	"CONCEN", ConcenMsg,
	"CIN", CinMsg,
	"EK", EkMsg,
	"ACTIVATION", StoreMsg,
	"SAVE", StoreMsg,
	NULL, NULL,
    };

    int i;

    for (i = 0 ; pggmm[i].pcG2 ; i++)
    {
	if (strcmp(pcTypename, pggmm[i].pcG2) == 0)
	{
	    if ((int)pggmm[i].MsgProcess == 0)
	    {
	    }

	    if ((int)pggmm[i].MsgProcess == 1)
	    {
		return 1;
	    }

	    return pggmm[i].MsgProcess(pcSrcpath, pcDstpath, pcField, pggmm[i].pcG2);
	}
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
static int AxialMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName)
{
    struct PidinStack *ppistSrc = getRootedContext(pcSrcpath);
  
    struct PidinStack *ppistDst = getRootedContext(pcDstpath);

    // \todo: this should not be: performance, and because it is
    // currently required, this means that the system is in an
    // inconsistent state.  This needs more investigation, likely the
    // best solution is to have a gateway that monitors more closely
    // what is going on in the model-container and calls
    // SymbolRecalcAllSerials() at the correct times and with the
    // correct arguments.

    if (!iFromTheCellReader)
    {
	SymbolRecalcAllSerials(NULL, NULL);
    }

    struct symtab_HSolveListElement *phsleSrc = PidinStackLookupTopSymbol(ppistSrc);

    struct symtab_HSolveListElement *phsleDst = PidinStackLookupTopSymbol(ppistDst);

    if (!phsleSrc)
    {
	Error();
	printf("source %s of axial msg is not found in the Model Container.\n", pcSrcpath);
	return 0;
    }

    if (!phsleDst)
    {
	Error(); 
	printf("dest %s of axial msg is not found in the Model Container.", pcDstpath);
	return 0;
    }

    //- construct the parent parameter

    struct PidinStack *ppistParent
	= PidinStackSubtract(ppistSrc, ppistDst);

    PidinStackCompress(ppistParent);

    struct symtab_IdentifierIndex *pidinParent
	= PidinStackToPidinQueue(ppistParent);

    struct symtab_Parameters *pparParentNew
	= ParameterNewFromPidinQueue("PARENT", pidinParent, TYPE_PARA_SYMBOLIC);

    //- if this symbol already has a parent parameter

    struct symtab_Parameters *pparParentOld
	= SymbolFindParameter(phsleDst, ppistDst, "PARENT");

    if (pcSrcpath[0] == '/' || pcDstpath[0] == '/')
    {
	//- use parameter caches

	int iSerialDst = PidinStackToSerial(ppistDst);

	if (iSerialDst == INT_MAX)
	{
	    Error(); 
	    printf("dest %s of axial msg cannot be converted to its serial.", pcDstpath);

	    PidinStackFree(ppistSrc);

	    PidinStackFree(ppistDst);

	    return 0;
	}

	struct neurospaces_integrator *pnsintegrator
	    = getNsintegrator();

	SymbolCacheParameter(pnsintegrator->phsleCachedRoot, PidinStackToSerial(ppistDst), pparParentNew);
    }

    //- else

    else
    {
	//- attach it to the symbol

	BioComponentChangeParameter((struct symtab_BioComponent *)phsleDst, pparParentNew);
    }

    PidinStackFree(ppistSrc);

    PidinStackFree(ppistDst);

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
static int ChannelMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName)
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
static int CalciumPoolMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName)
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

  struct symtab_IdentifierIndex *pidinTarget = PidinStackToPidinQueue(ppist);
  
  
  //! create 'I'
  struct symtab_IdentifierIndex *pidinI = IdinNewFromChars("I");


  pidinI->pidinRoot = pidinTarget;
  pidinI->iFlags = FLAG_IDENTINDEX_FIELD;

  struct symtab_IdentifierIndex *pidin;
  for(pidin = pidinTarget; pidin->pidinNext ;pidin = pidin->pidinNext);
  
  pidin->pidinNext = pidinI;


  struct symtab_InputOutput *pio = InputOutputNewForType(INPUT_TYPE_INPUT);

  if(!pio)
  {
    return 0;
  }


  pio->pidinField = pidinTarget;

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
static int VoltageMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName)
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
static int ConcenMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName)
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
static int CinMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName)
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
static int EkMsg(char *pcSrcpath, char *pcDstpath, char *pcField, char *pcMsgName)
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

   piom->iTarget = INT_MAX;

   piom->pcMsgName = strdup(pcMsgName);

   piom->iHeccerIndex = -1;

   //   piom->dValue = FLT_MAX;

   pnsintegrator->ppioMsg[pnsintegrator->iIoMsgs++] = piom;

   //- free allocated memory

   free(pcSrcpath);

   free(pcField);

   //- return success

   return 1;

}









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

  for (i = 0 ; i < pnsintegrator->iIoMsgs ; i++)
  {

      //- asc_out save messages

      if (!strcmp(ppioMsg[i]->pcMsgName, "SAVE"))
      {
	  //- are not processed overhere, so continue

	  // \todo useful comment above ... where again were they processed?

	  continue;
      }

    if (ppioMsg[i]->pcSourceSymbol)
    {

	//- resolve source

	if (!ppioMsg[i]->ppistSource)
	{
	    ppioMsg[i]->ppistSource
		= PidinStackParse(ppioMsg[i]->pcSourceSymbol);

	    ppioMsg[i]->phsleSource
		= PidinStackLookupTopSymbol(ppioMsg[i]->ppistSource);
	}

	//- fetch value

	// \todo: this is still a slow operation for simulation time ...

	ppioMsg[i]->dValue
	    = SymbolParameterResolveValue(ppioMsg[i]->phsleSource, ppioMsg[i]->ppistSource, ppioMsg[i]->pcSourceField);

	//- unlike in the model-container, in G2 all fields have a default value of zero

	if (ppioMsg[i]->dValue == FLT_MAX)
	{
	    ppioMsg[i]->dValue = 0;
	}

	//- resolve target

	if (ppioMsg[i]->iTarget == INT_MAX)
	{
	    ppioMsg[i]->ppistTarget
		= PidinStackParse(ppioMsg[i]->pcTargetSymbol);

	    PidinStackUpdateCaches(ppioMsg[i]->ppistTarget);

	    ppioMsg[i]->iTarget = PidinStackToSerial(ppioMsg[i]->ppistTarget);
	}

	//
	// Here we get the index to the solver which is
	// rooted in the target object
	//
	if(ppioMsg[i]->iHeccerIndex == -1)
	{

	    ppioMsg[i]->iHeccerIndex = 
		LookupHeccerIndex(ppioMsg[i]->pcTargetSymbol);
	}


	if (!ppioMsg[i]->pdValue)
	{

	    int iWorkingHeccerIndex = ppioMsg[i]->iHeccerIndex;

	    //
	    // If we have a cached index we use it, if not
	    // we leave pdValue as null and let the regular error 
	    // chacking catch it below.
	    //
	    if(iWorkingHeccerIndex != -1)
		ppioMsg[i]->pdValue
		    = HeccerAddressVariable(pnsintegrator->psr[iWorkingHeccerIndex].uSolver.si.pheccer, 
					    ppioMsg[i]->iTarget, 
					    ppioMsg[i]->pcMsgName);
	}

	if (ppioMsg[i]->pdValue)
	{
	    if (!strcmp(ppioMsg[i]->pcMsgName, "ACTIVATION"))
	    {
		//- add source to target

		*ppioMsg[i]->pdValue += ppioMsg[i]->dValue * clock_value[0];
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

  }

  return 1;

}

