
#include "neurospaces_defs.h"
#include "neurospaces_ext.h"
#include "neurospaces_struct.h"

#include "neurospacesquery.h"
#include "neurospacessetup.h"

#include "neurospaces/neurospaces.h"
#include "neurospaces/solvermapper.h"

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


