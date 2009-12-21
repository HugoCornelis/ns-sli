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
 *   the model container is full coupling.
 *
 */
//-------------------------------------------------------------------
int NSCopy(struct PidinStack *ppistSrc, char *pcDst, int iKeepPrototypeTraversal)
{
    struct symtab_HSolveListElement *phsleDst = NULL;

    struct symtab_HSolveListElement * phsleSrc
	= PidinStackLookupTopSymbol(ppistSrc);

    if (!phsleSrc)
    {
	char pc[1000];

	PidinStackString(ppistSrc, pc, sizeof(pc));

	fprintf(stderr, "Cannot find %s\n", pc);

	return 0;
    }

    //- create destination context

    struct PidinStack *ppistDst = getRootedContext(pcDst);

    struct symtab_IdentifierIndex *pidinDst = PidinStackPop(ppistDst);

    if (!pidinDst)
    {
	fprintf(stderr, "Could not create pidin %s\n", pcDst);

	return 0;
    }

    //- if making a copy of a segment

    if (instanceof_segment(phsleSrc))
    {
	//- try to register the parent for simulation

	char pc[1000];

	PidinStackString(ppistDst, pc, sizeof(pc));

	if (AttemptHeccerName(pc) == -1)
	{
	    return(0);
	}
    }

    //- if the destination is at the root

    if (PidinStackIsRooted(ppistDst))
    {
	//t copy /h/c /i/d
    }

    //- else

    else
    {
	//- the destination container is the full pathname

	//t copy /h/c /h/d
	//t ce /h ; cp c d

	PidinStackPushCompact(ppistDst, pidinDst);
    }

    //- create the copy

    // \note: pcName used for namespace, \todo this is subject to
    // removal for reason of efficiency

    char *pcName = getRootedPathname(pcDst);

    phsleDst = SymbolCreateAlias(phsleSrc, pcName, pidinDst);

    if (instanceof_bio_comp(phsleDst))
    {
	struct symtab_BioComponent *pbioDst
	    = (struct symtab_BioComponent *)phsleDst;

	//- if explicit request was made to keep prototype children visible

	if (iKeepPrototypeTraversal)
	{
	}

	//- else

	else
	{
	    //- if the original has no children yet

	    int iHasChildren = (SymbolGetPrincipalNumOfSuccessors(phsleSrc) != 0);

	    if (!iHasChildren)
	    {
		//- we assume there is a possibility that the source will
		//- get children in the future, so ...

		//- ... prevent a traversal over the alias to see the
		//- children of the original

		SymbolSetOptions
		    (phsleDst, (SymbolGetOptions(phsleDst) | BIOCOMP_OPTION_NO_PROTOTYPE_TRAVERSAL));
	    }
	    else
	    {
		int iBreak = 1;
	    }
	}
    }

    //- copy to the destination location

    struct symtab_HSolveListElement *phsleDstParent
	= PidinStackLookupTopSymbol(ppistDst);

    SymbolAddChild(phsleDstParent, phsleDst);

    PidinStackFree(ppistDst);

    return 1;
}


