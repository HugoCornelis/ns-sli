

//------------------------------------------------------------
/*!
 *   \file hsolveactor.c
 *   \author Hugo Cornelis
 *
 * An empty stub for definition of hsolve specific fields.
 *
 */
//-------------------------------------------------------------

#include <string.h>
#include <strings.h>

#include "nsintegrator.h"
#include "hsolve_g@.h"


//-------------------------------------------------------------
/*
 *r
 */
//-------------------------------------------------------------
int HSolveActor(struct hsolve_type *phsolve_type,
			       Action *action){

  


    struct hsolve_type *pasc = phsolve_type;
  
    //- set default result : ok
    int iResult = 1;

    //- select action

    SELECT_ACTION(action)
    {
    }

    //- return result

    return(iResult);
}


int NSSolverDuplicate(int argc, char **argv)
{
    if (argc != 5)
    {
	Error();

	printf("usage : %s <target> <target-path>\n", "DUPLICATE");

	return(0);
    }

    char *pcAction = argv[2];
    char *pcTarget = argv[3];
    char *pcTargetPath = argv[4];

    if (pcTargetPath[0] != '.'
	|| pcTargetPath[1] != '.')
    {
	Error();

	printf("The %s action only supports target paths that are prefixed with '..'\n", pcAction);

	return(0);
    }

    if (pcTarget[0] != '/')
    {
	Error();

	printf("The %s action only supports target element names that are prefixed with '/'\n", pcAction);

	return(0);
    }

    //- convert name to reference to parent element

    char pcParent[1000];

    strcpy(pcParent, pcTarget);

    char *pcSlash = rindex(pcParent, '/');

    *pcSlash = '\0';

    //- create the solver

    int iCreated = NSCreate(pcTarget, pcParent, "hsolve");

    if (iCreated != NSINTEGRATOR_NEUTRAL)
    {
	Error();

	printf("The %s action failed to create solver %s\n", pcAction, pcTarget);

	return(0);
    }

    SymbolRecalcAllSerials(NULL, NULL);    

    //- share operations with the source solver

    //- copy operands from the source solver

    OK();

    return 1;
}


char * do_findsolvefield(argc,argv)
	int argc;
	char	**argv;
{
    if (argc < 4)
    {
	return NULL;
    }

    //- +1 for the terminator, +1 for the last space

    int len = 2;

    //- compute length

    int i;

    for (i = 0 ; i < argc ; i++)
    {
	len += 1 + strlen(argv[i]);
    }

    //- set result: the original G2 command line

    char *pcResult = (char *)calloc(len, sizeof(char));

    for (i = 0 ; i < argc ; i++)
    {
	strcat(pcResult, argv[i]);

	strcat(pcResult, "&");
    }

    //- return result

    return(pcResult);
}


int undo_findsolvefield(char **ppcElement, char **ppcField)
{
    //- set default result: non-hsolved

    int iResult = 0;

    //- if this would be an hsolved field in G2

    if (strncmp(*ppcField, "findsolvefield", strlen("findsolvefield")) == 0)
    {
	//- parse the original G2 command again

	char *pcCommand = *ppcField;

	char *pcHSolver = strchr(pcCommand, '&');
	pcHSolver[0] = '\0';
	pcHSolver++;

	char *pcSolvedElement = strchr(pcHSolver, '&');
	pcSolvedElement[0] = '\0';
	pcSolvedElement++;

	char *pcSolvedField = strchr(pcSolvedElement, '&');
	pcSolvedField[0] = '\0';
	pcSolvedField++;

	char *pc = strchr(pcSolvedField, '&');

	if (pc)
	{
	    pc[0] = '\0';
	}

	//- the solved element contains the source of the message if
	//- hsolve would not be used

	char *pcSolvedElement2 = NULL;

	if (pcSolvedElement[0] == '/')
	{
	    pcSolvedElement2 = strdup(pcSolvedElement);
	}
	else
	{
	    pcSolvedElement2
		= (char *)calloc(1 + strlen(pcHSolver) + strlen("/") + strlen(pcSolvedElement), sizeof(char));

	    strcpy(pcSolvedElement2, pcHSolver);

	    strcat(pcSolvedElement2, "/");

	    strcat(pcSolvedElement2, pcSolvedElement);
	}

	*ppcElement = pcSolvedElement2;

	*ppcField = strdup(pcSolvedField);

	//- set result: hsolved

	iResult = 1;
    }
    else
    {
	*ppcElement = strdup(*ppcElement);

	*ppcField = strdup(*ppcField);
    }

    //- return result

    return(iResult);
}
