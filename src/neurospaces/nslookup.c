//------------------------------------------------------------------
/*!
 *  \file nslookup.c
 *  \author Mando Rodriguez
 *
 *  
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

#include "neurospaces/function.h"
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"


//-------------------------------------------------------------------------
/*
 */
//-------------------------------------------------------------------------
struct symtab_HSolveListElement * NSLookupHSolveListElement(char *pcPath){


    struct PidinStack *ppist  = PidinStackParse(pcPath);


    if(!ppist)
      return NULL;

    struct symtab_HSolveListElement *phsle = 
      PidinStackLookupTopSymbol(ppist);

    if(!phsle)
      return NULL;

    return phsle;

}
