//------------------------------------------------------------------
/*!
 *  \file nscall.c
 *  \author Mando Rodriguez
 *
 *  This file contains functions for parsing out GENESIS calls made
 *  to objects that are in the model-container and have no presensce 
 *  in the element namespace.
 * 
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "shell_func_ext.h"


#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"

#include "nsintegrator.h"



//-------------------------------------------------------------
/*!
 *  \fn int NSCall(char *pcAction, int argc, char **argv)
 *  \param argc argument count.
 *  \param argv argument vector.
 *
 *  Execute an G-2 action on an element.
 */
//--------------------------------------------------------------

int NSCall(int argc, char **argv)
{
    // define known element actions and their implementation

    struct g2_g3_action_mapper
    {
	char *pcAction;

	int (*ActionProcess)(int argc, char **argv);
    };	

    struct g2_g3_action_mapper pggam[] =
	{
	    "TABCREATE", NSTabCreate,
	    "TABFILL", NSTabFill,
	    "TABSAVE", (int (*)(int argc, char **argv))1,

	    "SETUP", (int (*)(int argc, char **argv))1,
	    "DUPLICATE", NSSolverDuplicate,

	    NULL, NULL,
	};

    //- extract the action name from the argument vector

    char *pcAction = argv[2];

    //- loop over all known element actions

    int i;

    for (i = 0 ; pggam[i].pcAction != NULL; i++)
    {
	//- if the action names match

	if (strcmp(pcAction, pggam[i].pcAction) == 0)
	{
	    // shared code from the message mapper

	    if (pggam[i].ActionProcess == NULL)
	    {
	    }

	    //- if there is no implementation

	    if (pggam[i].ActionProcess == (int (*)(int argc, char **argv))1)
	    {
		//- return that the action has been processed here

		return 1;
	    }

	    //- call the implementation function of this action

	    return pggam[i].ActionProcess(argc, argv);
	}
    }

    //- the action is assumed to be in old G-2 code

    return 0;
}


