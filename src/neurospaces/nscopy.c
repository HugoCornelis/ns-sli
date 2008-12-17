//------------------------------------------------------------------
/*!
 *  \file nscopy.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for copying objects in
 *  the Neurospaces Model Container via the GENESIS scripting 
 *  language.
*/
//-------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"


#include "neurospaces/symbols.h"  
#include "neurospaces/symboltable.h"  
#include "neurospaces/pidinstack.h"

//t includes from our nsgenesis library
#include "neurospaces/nsintegrator.h"


//-------------------------------------------------------------------
/*!
 *   \fn int NSCopy(const Element* pelSrcelement, char *pcDstname)
 *   \param pelSrcelement A pointer to the element to be copied.
 *   \param pcDstname A character array with the name for the new element.
 *   \return 0 on error, 1 on success.
 *
 *
 *   Function copies an Element into a newly allocated element with 
 *   name pcDstname.
 */
//-------------------------------------------------------------------
int NSCopy(struct PidinStack *ppistSrc, char *pcDst){


  struct symtab_HSolveListElement *phsleDst = NULL;


  struct symtab_HSolveListElement * phsleSrc  = 
    PidinStackLookupTopSymbol(ppistSrc);


  if(!phsleSrc){

    char pc[1000];

    
    PidinStackString(ppistSrc, pc, sizeof(pc));
    fprintf(stderr, "Cannot find %s\n", pc);
    return 0;

  }



  //t copy /h/c /h/d
  //t ce /h ; cp c d

  //t copy /h/c /i/d


  struct PidinStack *ppistDst = PidinStackParse(pcDst);


  struct symtab_IdentifierIndex *pidinDst = PidinStackPop(ppistDst);

  if(!pidinDst){

    fprintf(stderr,"Could not create pidin %s\n",pcDst);
    return 0;

  }


  if (PidinStackIsRooted(ppistDst))
    {
      //t nothing ?
    }
  else
    {
      PidinStackPushCompact(ppistDst,pidinDst);
    }
  
   
/*   char *pcDstname = strdup(pcDst); */
/*   pidinDst = IdinNewFromChars(pcDstname); */



  phsleDst = SymbolCreateAlias(phsleSrc,pidinDst);
 

  //t
  //t Will only copy to the parent of the Src.
  //t
  struct symtab_HSolveListElement *phsleDstParent = 
    PidinStackLookupTopSymbol(ppistDst);


  SymbolAddChild(phsleDstParent,phsleDst);

  PidinStackFree(ppistDst);

  return 1;
}
