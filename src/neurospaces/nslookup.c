//------------------------------------------------------------------
/*!
 *  \file nslookup.c
 *  \author Mando Rodriguez
 *
 *  A simple lookup function.
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "shell_func_ext.h"


#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"


//-------------------------------------------------------------------------
/*!
 * \fun struct symtab_HSolveListElement * NSLookupHSolveListElement(char *pcPath)
 * \param pcPath A symbol identifier to look up.
 * \return A pointer to the Element that pcPath points to.
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
