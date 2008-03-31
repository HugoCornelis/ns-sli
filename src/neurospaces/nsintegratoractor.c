
#include "nsintegrator.h"



int NeurospacesIntegratorActor(struct nsintegrator_type *pnsintegrator,Action *action)
{
    //- set default result : ok

    int iResult = 1;

    //- select action

    SELECT_ACTION(action)
	{

	//- create

	case CREATE:
	{
	    break;
	}
	}

    //- return result

    return(iResult);
}


