//------------------------------------------------------------------
/*!
 *  \file nssetfield.c
 *  \author Mando Rodriguez
 *
 *  File contains the code for setting element fields for model container
 *  objects that are referenced in the GENESIS namespace.
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>

#include "shell_func_ext.h"

#include <heccer/addressing.h>
#include "nsintegrator.h"
#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"



/*!
 *
 * \return 1 on success, -1 on error, 0 on not found in model container.
 */
int NSShowField(char *pcPathname, char *pcField,int iOptions)
{

  if(!pcPathname || !strcmp(pcPathname,""))
  {
    return 0;
  }

  //
  // If there is no field set then don't bother. Let
  // GENESIS report the error.
  //
  if(!pcPathname || !strcmp(pcPathname,""))
  {
    return 0;
  }


  struct PidinStack *ppist = PidinStackParse(pcPathname);

  struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist); 


  //
  // If no symbol if found then we exit and let GENESIS continue 
  // to process the request.
  //
  if(!phsle)
  {
    return 0;
  }


  //
  // Handling wildcards.  
  //
  if(!strcmp(pcField,"*"))
  {
    // if we have one star then we print all fields (parameters)
   
   
    return 1;
  }
  else if(!strcmp(pcField,"**"))
  {

    // if we have two stars then we print all extended fields.


    return 1;
  }
  else
  {
    
    // else we print a specific parameter.

    struct symtab_Parameters *ppar = SymbolFindParameter(phsle, ppist, pcField);
  
    int bResult;

    if (ppar)
    {
      fprintf(stdout, "%s", "---\n");

      int iResult = ParameterPrint(ppar,1,0,stdout);

      if (!iResult)
      {
	bResult = 0;
      }
      else
      {
	fprintf(stdout, "parameter not found\n");
      }
    
    }
    else 
    {
      fprintf(stdout, "parameter %s not found\n",pcField);
      return 1;
    }


  }

}


