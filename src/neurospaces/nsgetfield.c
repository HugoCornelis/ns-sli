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

  // First we check for the variable in heccer

  char *pcHeccerVar = GetHeccerParameter(pcPathname,pcField);

  if(pcHeccerVar)
  {
    
    return(CopyString(pcHeccerVar));

  }


  // if it's not in heccer then we proceed to check the model
  // container.

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





//--------------------------------------------------------
/*
 *
 */
//---------------------------------------------------------
char * GetHeccerParameter(char *pcName,char *pcParameter)
{


  struct neurospaces_integrator *pnsintegrator = getNsintegrator();
  
  
  struct Heccer **ppheccer = pnsintegrator->ppheccer;
  int iHeccers = pnsintegrator->iHeccers;


  struct PidinStack *ppist = PidinStackParse(pcName);

  PidinStackUpdateCaches(ppist);

  int iSerial = PidinStackToSerial(ppist);

  // for now getfield will only check on the heccer object 
  // at index 0. 

  double *pdValue = (double *)HeccerAddressVariable(ppheccer[0],iSerial,pcParameter);

  if(!pdValue || (*pdValue) == FLT_MAX)
    return NULL;


  char pc[100];

  sprintf(pc,"%g",(*pdValue));

  return pc;

}
