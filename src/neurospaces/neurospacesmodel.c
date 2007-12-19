
#include "neurospaces_defs.h"
#include "neurospaces_ext.h"
#include "neurospaces_struct.h"

#include "neurospacesquery.h"
#include "neurospacessetup.h"

#include "neurospaces/neurospaces.h"
#include "neurospaces/solvermapper.h"


// extern NeuroSpacesSetupSymbol neurospacessetup_cellsolver;

// extern NeuroSpacesSetupSymbol neurospacessetup_populationsolver;

// extern NeuroSpacesSetupSymbol neurospacessetup_projection;

// extern NeuroSpacesSetupSymbol neurospacessetup_randomspike;


int DEBUG_NeuroSpacesActor = 0;


int NeuroSpacesActor(struct neurospaces_type *pneuro,Action *action)
{
    //- set default result : ok

    int iResult = 1;

    //- give debug info

    if(Debug(DEBUG_NeuroSpacesActor) > 1)
    {
	ActionHeader("NeuroSpacesActor",pneuro,action);
    }

    //- select action

    SELECT_ACTION(action)
	{

	//- create

	case CREATE:
	{
	    break;
	}

/* 	//- read */

/* 	case NEUROSPACES_READ: */
/* 	{ */
/* 	    static struct SolverMapper */
/* 		map[] = */
/* 	    { */
/* 		{ */
/* 		    "population", */
/* 		    TYPE_HSLE_POPULATION, */
/* 		    NULL, */
/* 		    neurospacessetup_populationsolver, */
/* 		}, */
/* 		{ */
/* 		    "cell", */
/* 		    TYPE_HSLE_CELL, */
/* 		    NULL, */
/* 		    neurospacessetup_cellsolver, */
/* 		}, */
/* 		{ */
/* 		    "segmentgroup", */
/* 		    TYPE_HSLE_VECTOR_SEGMENT, */
/* 		    NULL, */
/* 		    NULL, */
/* 		}, */
/* 		{ */
/* 		    "projection", */
/* 		    TYPE_HSLE_PROJECTION, */
/* 		    NULL, */
/* 		    neurospacessetup_projection, */
/* 		}, */
/* 		{ */
/* 		    "randomspike", */
/* 		    TYPE_HSLE_FIBER, */
/* /\* 		    TYPE_HSLE_RANDOMVALUE, *\/ */
/* 		    NULL, */
/* 		    neurospacessetup_randomspike, */
/* 		}, */
/* 		{ */
/* 		    NULL, */
/* 		    -1, */
/* 		    NULL, */
/* 		    NULL, */
/* 		}, */
/* 	    }; */

/* 	    map[0].pvUserdata = (void *)pneuro; */
/* 	    map[1].pvUserdata = (void *)pneuro; */
/* 	    map[2].pvUserdata = (void *)pneuro; */
/* 	    map[3].pvUserdata = (void *)pneuro; */
/* 	    map[4].pvUserdata = (void *)pneuro; */

/* 	    //- read neurospacesmodel */

/* 	    pneuro->pneuro */
/* 		= NeuroSpacesNewFromCmdLine */
/* 		  (action->argc + 1,&action->argv[-1]); */

/* 	    //- register mapping to solution engines */

/* 	    NeuroSpacesSetSolverMapper(pneuro->pneuro,map); */

/* 	    break; */
/* 	} */

/* 	//- SETUP */

/* 	case NEUROSPACES_SETUP: */
/* 	{ */
/* 	    //- setup solvers */

/* 	    neurospacessetup(pneuro,action->argc + 1,&action->argv[-1]); */

/* 	    break; */
/* 	} */

	//- RESET
	//- query

	case NEUROSPACES_QUERY:
	{
	    //- start query machine

	    neurospacesquery(pneuro);
	    break;
	}
	}

    //- return result

    return(iResult);
}


