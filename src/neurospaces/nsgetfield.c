//------------------------------------------------------------------
/*!
 *  \file nsgetfield.c
 *  \author Mando Rodriguez
 *
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "sim_ext.h"
#include "shell_func_ext.h"

#include <heccer/addressing.h>
#include "nsintegrator.h"
#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"


/*
 * Return -1 on continue, NULL on error, pointer on success.
 */
char* NSGetField(char *pcPathname,char *pcField)
{

  struct PidinStack *ppist = PidinStackParse(pcPathname);

  struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

  if(!phsle)
  {
    // in this case it's not in the model container.
    return -1;
  }

  char *pcMappedPar = mapParameterString(pcField);

  double iValue = SymbolParameterResolveValue(phsle,ppist,pcMappedPar);
  

  if(iValue == FLT_MAX)
  {
    Error();
    printf("could not get the value for field '%s'\n",pcField);
    return(NULL);  
  }


  char pc[100];

  sprintf(pc,"%g",iValue);


  return(CopyString(pc));

}
