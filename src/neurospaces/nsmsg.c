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


#include "neurospaces/symbols.h"  
#include "neurospaces/symboltable.h"  
#include "neurospaces/pidinstack.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/function.h"

//t includes from our nsgenesis library"
#include "neurospaces/nsintegrator.h"



static int AxialMsg(const char *pcSrcpath, const char *pcDstpath);
static int ChannelMsg(const char *pcSrcpath, const char *pcDstpath);
static int CalciumPoolMsg(const char *pcSrcpath, const char *pcDstpath);
static int VoltageMsg(const char *pcSrcpath, const char *pcDstpath);
static int ConcenMsg(const char *pcSrcpath, const char *pcDstpath);
static int CinMsg(const char *pcSrcpath, const char *pcDstpath);
static int EkMsg(const char *pcSrcpath, const char *pcDstpath);


static struct symtab_IOContainer *IOContainerFromList(char *ppcParmaters[], int iType[]);
static struct symtab_IdentifierIndex * PidinQueueLookupTarget(const char *pcSrcpath, 
							      const char *pcDstpath);


//-------------------------------------------------------------------
/*!
 *   \fn int NSmsg(const char *pcSrcpath, const char *pcDstpath, const char *pcTypename)
 *   \param pcSrcpath The identifier for the Parent HSolve element.
 *   \param pcDstpath The identidier for the Child HSolve element.
 *   \param pcTypename The "message" type to pass to from Parent to child.
 *   \return 0 on error, 1 on success.
 *
 *   Function creates a message between two objects.
 */
//-------------------------------------------------------------------
int NSmsg(const char *pcSrcpath, const char *pcDstpath, const char *pcTypename){


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
  else if(strcmp(pcTypename,"ACTIVATION") == 0){

    return 1;

  }



  return 0;
}




//---------------------------------------------------------------
/*!
 *  \fn int AxialMsg(const char *pcSrcpath, const char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 *
 *  This is done by setting the parameter pcSrcPath as "PARENT" and 
 *  linking this parameter to the phsle instace in pcDstPath via a
 *  reference.
 */
//----------------------------------------------------------------
static int AxialMsg(const char *pcSrcpath, const char *pcDstpath)
{


  struct PidinStack *ppistSrc = 
    (struct PidinStack *)PidinStackParse((char *)pcSrcpath);

  struct symtab_HSolveListElement *phsleSrc = 
    PidinStackLookupTopSymbol(ppistSrc);

  if(!phsleSrc){

    Error();
    printf("%s is not found in the Model Container.",phsleSrc);
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



  struct PidinStack *ppistDst =  
    (struct PidinStack *)PidinStackParse((char *)pcDstpath); 

      

  struct symtab_HSolveListElement *phsleDst =  
    PidinStackLookupTopSymbol(ppistDst); 

      

  if(!phsleDst){ 

    Error(); 
    printf("%s is not found in the Model Container.",phsleDst); 
    return 0; 
    
  } 


  BioComponentChangeParameter(
			      (struct symtab_BioComponent *)phsleDst, ppar);

  return 1;


}





//----------------------------------------------------------------------------
/*!
 *  \fn int ChannelMsg(const char *pcSrcpath, const char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.

 *  Creates a message between channels by way of bindables and bindings. 
 */
//----------------------------------------------------------------------------
static int ChannelMsg(const char *pcSrcpath, const char *pcDstpath)
{


  struct symtab_HSolveListElement *phsleSrc = NSLookupHSolveListElement(pcSrcpath);

  struct symtab_HSolveListElement *phsleDst = NSLookupHSolveListElement(pcDstpath);


  struct PidinStack *ppistSrc = PidinStackParse(pcSrcpath);
  
  struct PidinStack *ppistDst = PidinStackParse(pcDstpath);


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

  return 1;

}




//----------------------------------------------------------------------------
/*!
 *  \fn static int CalciumPoolMsg(const char *pcSrcpath, const char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 *
 *  Creates a message for a calcium pool via bindings and bindables.
 */
//----------------------------------------------------------------------------
static int CalciumPoolMsg(const char *pcSrcpath, const char *pcDstpath)
{


  struct symtab_HSolveListElement *phsleSrc = NSLookupHSolveListElement(pcSrcpath);

  struct symtab_HSolveListElement *phsleDst = NSLookupHSolveListElement(pcDstpath);


  struct PidinStack *ppistSrc = PidinStackParse(pcSrcpath);
  
  struct PidinStack *ppistDst = PidinStackParse(pcDstpath);


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
    return NULL;
  }


  pio->pidinField = idinTarget;

  //! ---------------- end inserted code ------------------------------

  SymbolAssignInputs(phsleDst, pio);



  return 1;

}



//----------------------------------------------------------------------------
/*!
 *  \fn static int VoltageMsg(const char *pcSrcpath, const char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 *
 *  Creates A voltage message by way of a "Vm" binding for input.
 *  
 */
//----------------------------------------------------------------------------
static int VoltageMsg(const char *pcSrcpath, const char *pcDstpath)
{

  struct symtab_HSolveListElement *phsleSrc = NSLookupHSolveListElement(pcSrcpath);

  struct symtab_HSolveListElement *phsleDst = NSLookupHSolveListElement(pcDstpath);


  struct PidinStack *ppistSrc = PidinStackParse(pcSrcpath);
  
  struct PidinStack *ppistDst = PidinStackParse(pcDstpath);


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


  return 1;
  
}






//----------------------------------------------------------------------------
/*!
 *  \fn static int ConcenMsg(const char *pcSrcpath, const char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 *
 *  Creates a concentration message by linking to the "concen" parameter
 *  in the destination element.
 */
//----------------------------------------------------------------------------
static int ConcenMsg(const char *pcSrcpath, const char *pcDstpath)
{


  struct symtab_HSolveListElement *phsleSrc = NSLookupHSolveListElement(pcSrcpath);

  struct symtab_HSolveListElement *phsleDst = NSLookupHSolveListElement(pcDstpath);


  struct PidinStack *ppistSrc = PidinStackParse(pcSrcpath);
  
  struct PidinStack *ppistDst = PidinStackParse(pcDstpath);


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



  return 1;


}




//-------------------------------------------------------------------------
/*!
 *  \fn static int CinMsg(const char *pcSrcpath, const char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 *
 *  Creates a Cin message via two parameter setting. A reference to a local
 *  cocen_init parameter, which references a concen_init parameter that is 
 *  in a pool. 
 */
//-------------------------------------------------------------------------
static int CinMsg(const char *pcSrcpath, const char *pcDstpath)
{


  struct symtab_HSolveListElement *phsleSrc = NSLookupHSolveListElement(pcSrcpath);

  struct symtab_HSolveListElement *phsleDst = NSLookupHSolveListElement(pcDstpath);


  struct PidinStack *ppistSrc = PidinStackParse(pcSrcpath);
  
  struct PidinStack *ppistDst = PidinStackParse(pcDstpath);


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


  setParameter(phsleSrc,"Cin",".->concen_init",SETPARA_FIELD);
  

  PidinStackString(ppistTarget,pcTarget,sizeof(pcTarget));

  int iLen = strlen(pcTarget);

  strcpy(&pcTarget[iLen],"->Cin");


  int iResult = setParameter(phsleDst,"Cin",pcTarget,SETPARA_FIELD);

  if(!iResult)
  {

    fprintf(stderr,"Error adding message from %s to %s\n",pcSrcpath,pcDstpath);
    return -1;
    
  }


  return 1;

}




//-------------------------------------------------------------------------
/*!
 *  \fn static int EkMsg(const char *pcSrcpath, const char *pcDstpath)
 *  \param pcSrcpath The identifier for the Parent HSolve element.
 *  \param pcDstpath The identidier for the Child HSolve element.  
 *  \return 0 on error, 1 on success.
 */
//-------------------------------------------------------------------------
static int EkMsg(const char *pcSrcpath, const char *pcDstpath)
{


  struct symtab_HSolveListElement *phsleSrc = NSLookupHSolveListElement(pcSrcpath);

  struct symtab_HSolveListElement *phsleDst = NSLookupHSolveListElement(pcDstpath);


  struct PidinStack *ppistSrc = PidinStackParse(pcSrcpath);
  
  struct PidinStack *ppistDst = PidinStackParse(pcDstpath);


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


  int iResult = setParameter(phsleDst,"Erev",pcTarget,SETPARA_FIELD);

  if(!iResult)
  {

    fprintf(stderr,"Error adding message from %s to %s\n",pcSrcpath,pcDstpath);
    return -1;
    
  }

  return 1;

}
