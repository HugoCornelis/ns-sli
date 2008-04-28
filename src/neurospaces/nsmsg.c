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

  return 0;
}
