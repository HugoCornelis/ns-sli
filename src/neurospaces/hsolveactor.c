

//------------------------------------------------------------
/*!
 *   \file hsolveactor.c
 *   \author Hugo Cornelis
 *
 * An empty stub for definition of hsolve specific fields.
 *
 */
//-------------------------------------------------------------
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


char * do_findsolvefield(argc,argv)
	int argc;
	char	**argv;
{
    if (argc < 4)
    {
	return NULL;
    }

    return strdup(argv[3]);
}


