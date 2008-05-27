//------------------------------------------------------------------
/*!
 *  \file nscomm.c
 *  \author Mando Rodriguez
 *
 *  This file holds commodity functions for performing some actions 
 *  in the model container and Heccer.
*/
//------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

#include "neurospaces/function.h"
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"

#include "nsintegrator.h"



//--------------------------------------------------------------------

//--------------------------------------------------------------------
struct symtab_HSolveListElement *PidinStackGetPhsle(struct PidinStack *ppist, char *pcName){


  int iCheck = PidinStackPushString(ppist,pcName);

  if(!iCheck)
    return NULL;

  struct symtab_HSolveListElement *phsleResult =  
    PidinStackLookupTopSymbol(ppist);

  return phsleResult;

}


//-------------------------------------------------------------------
/*
 *
 */
//-------------------------------------------------------------------
int PidinStackPushString(struct PidinStack *ppist,char *pcName){


  struct symtab_IdentifierIndex *pidin
    = IdinNewFromChars(pcName);

  if(!pidin)
    return 0;

  PidinStackPush(ppist, pidin);

  return 1;

}
