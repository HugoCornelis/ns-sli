//------------------------------------------------------------------
/*!
 *  \file nsmove.c
 *  \author Hugo Cornelis
 *
 *  This file contains the implementation for moving objects in the
 *  Neurospaces Model Container via the GENESIS scripting language.
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
 *   \fn int NSMove()
 *   \param ppistSrc A pointer to the element to be copied.
 *   \param pcDst A character array with the name for the new element.
 *   \param pcName new name of the target symbol.
 *   \param iIndex new index of the target symbol.
 *   \return 0 on error, 1 on success.
 *
 *   Function moves a symbol to a new location.
 *
 */
//-------------------------------------------------------------------
int NSMove(struct PidinStack *ppistSrc, char *pcDst, char *pcName, int iIndex)
{
    struct PidinStack *ppistDst
	= getRootedContext(pcDst);

    if (!ppistDst)
    {
	char pc[100];

	PidinStackString(ppistSrc, pc, sizeof(pc));

	Error();

	printf("could not move %s to %s in the neurospaces model container, destination not found\n", pc, pcDst);

	return(0);
    }

    struct symtab_HSolveListElement *phsleSrc
	= PidinStackLookupTopSymbol(ppistSrc);

    PidinStackPop(ppistSrc);

    struct symtab_HSolveListElement *phsleParent
	= PidinStackLookupTopSymbol(ppistSrc);

    SymbolDeleteChild(phsleParent, phsleSrc);
	
    char pc[100];

    char *pcNameDst = SymbolGetName(phsleSrc);

    if (pcName)
    {
	struct symtab_IdentifierIndex *pidinDst = NULL;

	if (iIndex != 0)
	{
	    sprintf(pc, "%s[%i]", pcName, iIndex);

	    pcNameDst = pc;
	}
	else
	{
	    pcNameDst = pcName;
	}

	pidinDst = IdinNewFromChars(strdup(pcNameDst));

	SymbolSetName(phsleSrc, pidinDst);

	PidinStackPop(ppistDst);
    }

    struct symtab_HSolveListElement *phsleDst
	= PidinStackLookupTopSymbol(ppistDst);

    if (!phsleDst)
    {
	char pc[100];

	PidinStackString(ppistSrc, pc, sizeof(pc));

	PidinStackFree(ppistDst);

	Error();

	printf("could not move %s to %s in the neurospaces model container, destination symbol not found\n", pc, pcDst);

	return(0);
    }

    //- create an alias of the destination such that new children
    //- can be added to the alias after the move operation has
    //- completed

    phsleSrc = SymbolCreateAlias(phsleSrc, strdup(pcName), IdinNewFromChars(SymbolGetName(phsleSrc)));

    //- add the alias as new child to the source of the move

    SymbolAddChild(phsleDst, phsleSrc);

    struct nsintegrator_type *pelnsintegrator
	= (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

    SymbolRecalcAllSerials(NULL, NULL);

    PidinStackFree(ppistDst);

    return(1);
}


