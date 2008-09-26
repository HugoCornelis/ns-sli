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
#include "sim_ext.h"


#include "neurospaces/segment.h"  
#include "neurospaces/symbols.h"  
#include "neurospaces/symboltable.h"  
#include "neurospaces/pidinstack.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/function.h"



//t includes from our nsgenesis library
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/nsintegrator.h"




static struct symtab_IOContainer *IOContainerFromList(char *ppcParmaters[], int iType[]);
static struct symtab_IdentifierIndex * PidinQueueLookupTarget(const char *pcSrcpath, 
							      const char *pcDstpath);

//-------------------------------------------------------------------
/*!
 *   \fn int NSmsg
 *   \param pcSrcPath The identifier for the Parent HSolve element.
 *   \param pcDstPath The identidier for the Child HSolve element.
 *   \param pcTypename The "message" type to pass to from Parent to child.
 *   \return 0 on error, 1 on success.
 *
 *   This is done by setting the parameter pcSrcPath as "PARENT" and 
 *   linking this parameter to the phsle instace in pcDstPath via a
 *   reference.
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


    return 1;

  }
  else if(strcmp(pcTypename,"CHANNEL") == 0){


    return ChannelMsg(pcSrcpath,pcDstpath);

  }


  return 0;
}




//---------------------------------------------------------------
/*!
 */
//----------------------------------------------------------------
int AxialMsg(const char *pcSrcpath, const char *pcDstpath)
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
/*
 *   \fun int ChannelMsg(const char *pcSrcpath, const char *pcTgtpath)
 */
//----------------------------------------------------------------------------
int ChannelMsg(const char *pcSrcpath, const char *pcDstpath)
{


  struct symtab_IdentifierIndex *pidinTarget =  
    PidinQueueLookupTarget(pcSrcpath,pcDstpath);


/*   struct PidinStack * */
/*     SymbolPrincipalSerial2Context(struct symtab_HSolveListElement *phsle, */
/* 				struct PidinStack *ppist,int iPrincipal); */




   //- bind I/O relations 

/*   SymbolAssignInputs(&$4->bio.ioh.iol.hsle, $3);  */


/*   ChannelSetup(struct  symtab_Channel *pchan,struct ParserContext *pac);  */

  return 1;

}




//----------------------------------------------------------------------------
/*!
 */
//----------------------------------------------------------------------------
int CalciumPoolMsg(const char *pcSrcpath, const char *pcDstpath)
{


  return 1;
}



//-----------------------------------------------------------------------------
/*!
 *
 */
//-----------------------------------------------------------------------------
static struct symtab_IOContainer *IOContainerFromList(char *ppcParmaters[], int iType[])
{


  int i;

  int iParameterLen = 0;

  for(iParameterLen=0;ppcParmaters[iParameterLen];iParameterLen++);
    
  
  struct symtab_InputOutput ** pios = 
    (struct symtab_InputOutput **)calloc(iParameterLen,sizeof(struct symtab_InputOutput*));


  //! 
  //! First create the ios and idins
  //!
  for( i=0; i<iParameterLen; i++)
  {

    struct symtab_IdentifierIndex *pidin = IdinNewFromChars(ppcParmaters[i]);

    struct symtab_InputOutput *pio = 
      InputOutputNewForType( iType[i] );


    //! set the pidin in the pidinField
    pio->pidinField = pidin;

    //! put this pio into our pios array
    pios[i] = pio;

    //! go ahead and set this to point at element 0
    pios[i]->pioFirst = pios[0];

  }


  //!
  //! Now make each parameter point to the next in succession.
  //!
  for(i=0;i<iParameterLen;i++)
  {

    if(i == iParameterLen - 1)
      pios[i]->pioNext = NULL;
    else
      pios[i]->pioNext = pios[i+1];

  }

  return IOContainerNewFromIO(pios);

} 




//-----------------------------------------------------------------------------------
/*
 */
//-----------------------------------------------------------------------------------
static struct symtab_IdentifierIndex * PidinQueueLookupTarget(const char *pcSrcpath, 
							      const char *pcDstpath)
{

  struct symtab_HSolveListElement *phsleSrc = NSLookupHSolveListElement(pcSrcpath);

  struct symtab_HSolveListElement *phsleDst = NSLookupHSolveListElement(pcDstpath);


  struct PidinStack *ppistSrc = PidinStackParse(pcSrcpath);
  
  struct PidinStack *ppistDst = PidinStackParse(pcDstpath);

  
  struct symtab_IdentifierIndex *pidinSrc = PidinStackToPidinQueue(ppistSrc);
  
  struct symtab_IdentifierIndex *pidinDst = PidinStackToPidinQueue(ppistDst);
  

  PidinStackPushCompactAll(ppistSrc,pidinSrc);
  PidinStackPushCompactAll(ppistDst,pidinDst);


  //!
  //! Fetch the cached root and context to recalculate all serials in the model
  //! container.
  //!
  struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  SymbolRecalcAllSerials(pelnsintegrator->pnsintegrator->phsleCachedRoot, 
                         pelnsintegrator->pnsintegrator->ppistCachedRoot);



  PidinStackUpdateCaches(ppistSrc);
  PidinStackUpdateCaches(ppistDst);


  
  int iSrc = PidinStackToSerial(ppistSrc);

  int iDst = PidinStackToSerial(ppistDst);


  int iPrincipal = iDst - iSrc;



  struct PidinStack *ppistTarget = 
    SymbolPrincipalSerial2Context(phsleDst, 
				  ppistDst,
				  iPrincipal);


  struct symtab_IdentifierIndex *pidinTarget = PidinStackToPidinQueue(ppistTarget);

  return pidinTarget;


}
