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

#include "nsintegrator.h"


//-------------------------------------------------------------------
/*!
 *   \fn int NSCopy(struct PidinStack *ppistSrc, char *pcDst)
 *   \param ppistSrc A pointer to the element to be copied.
 *   \param pcDst A character array with the name for the new element.
 *   \param iKeepPrototypeTraversal set to one if elements in the
 *   source are considered part of the new copy.
 *   \return 0 on error, 1 on success.
 *
 *
 *   Function copies an Element into a newly allocated element with 
 *   name pcDstname.
 *
 *   In certain circumstances it can be desirable that the elements
 *   added to the source element after the copy is made, also become
 *   children of the destination.  If the source had children before
 *   the copy is made, new children added to the source will be
 *   visible from the destination too.  OTOH, if the source had NO
 *   children before the copy is made, the source and destination
 *   become decoupled after the copy is made, ie. children added to
 *   the source are not visible from the destination and vice-versa.
 *
 *   This behaviour can be overriden using the iKeepPrototypeTraversal
 *   argument: if set to 1, elements of the source will always be
 *   visible from the destination.  This last behaviour is for example
 *   used by the cell reader.
 *
 *   Also note that the default behaviour of aliasses and aliassees in
 *   the model container if full coupling.
 *
 */
//-------------------------------------------------------------------
int NSCopy(struct PidinStack *ppistSrc, char *pcDst, int iKeepPrototypeTraversal){


  struct symtab_HSolveListElement *phsleDst = NULL;


  struct symtab_HSolveListElement * phsleSrc  = 
    PidinStackLookupTopSymbol(ppistSrc);


  if(!phsleSrc){

    char pc[1000];

    PidinStackString(ppistSrc, pc, sizeof(pc));
    fprintf(stderr, "Cannot find %s\n", pc);
    return 0;

  }


  if (instanceof_segment(phsleSrc))
  {
      char pc[1000];

      PidinStackString(ppistSrc, pc, sizeof(pc));

      if (AttemptHeccerName(pc) == -1)
      {
	  return(0);
      }
  }

  struct PidinStack *ppistDst = NULL;



  //i
  //i If the destination is not rooted then we must root it to the 
  //i current working element.
  //i
  if(pcDst[0] != '/')
  {
    Element *elmCurrentElement = GetElement(".");

    char *pcCurrentElement = Pathname(elmCurrentElement);

    char pcNewDst[1000];

    strcpy(pcNewDst, pcCurrentElement);


    //i
    //i If current working element is NOT "/" then we
    //i need to add a slash.
    //i 
    if(strcmp(pcCurrentElement,"/") != 0)
    {

      strcat(pcNewDst,"/");

    }

    strcat(pcNewDst,pcDst);

    ppistDst = PidinStackParse(pcNewDst);

  }
  else
  {

    ppistDst = PidinStackParse(pcDst);

  }

  struct symtab_IdentifierIndex *pidinDst = PidinStackPop(ppistDst);

  if(!pidinDst){

    fprintf(stderr,"Could not create pidin %s\n",pcDst);
    return 0;

  }


  if (PidinStackIsRooted(ppistDst))
    {

      //t copy /h/c /i/d
     
    }
  else
    {
      //t copy /h/c /h/d
      //t ce /h ; cp c d
      PidinStackPushCompact(ppistDst,pidinDst);
    }
  
   
/*   char *pcDstname = strdup(pcDst); */
/*   pidinDst = IdinNewFromChars(pcDstname); */


  char *pcName = strdup(pcDst);

  phsleDst = SymbolCreateAlias(phsleSrc,pcName,pidinDst);
 

  if (instanceof_bio_comp(phsleDst))
  {
      struct symtab_BioComponent *pbioDst
	  = (struct symtab_BioComponent *)phsleDst;

      //- if the original has no children yet

      int iHasChildren = (SymbolGetPrincipalNumOfSuccessors(phsleSrc) != 0);

      if (!iHasChildren
	  && !iKeepPrototypeTraversal)
      {
	  //- prevent traversal over the alias to see the children of
	  //- the original

	  SymbolSetOptions
	      (phsleDst, (SymbolGetOptions(phsleDst) | BIOCOMP_OPTION_NO_PROTOTYPE_TRAVERSAL));
      }
  }

  //t
  //t Will only copy to the parent of the Src.
  //t
  struct symtab_HSolveListElement *phsleDstParent = 
    PidinStackLookupTopSymbol(ppistDst);


  SymbolAddChild(phsleDstParent,phsleDst);

  PidinStackFree(ppistDst);

  return 1;
}
