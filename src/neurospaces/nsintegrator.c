//------------------------------------------------------------------
/*!
 *  \file nsintegrator.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for the initialization of
 *  the Neurospaces to GENESIS bridge. 
*/
//-------------------------------------------------------------------
#include "nsintegrator.h"
#include <stdlib.h>





//------------------------------------------------------------------
/*!
 *   \fn int NSGenesisInitialize()
 *   \return -1 on error, 1 on success.
 *   \sa neurospaces_integrator
 *
 *   Initializes the pnsintegrator.
 */
//------------------------------------------------------------------
int NSGenesisInitialize(struct Neurospaces *pneuro)
{
    struct neurospaces_integrator *pnsintegrator
	= (struct neurospaces_integrator *) calloc(1, sizeof(struct neurospaces_integrator));
       
    char *argvar[5];

    argvar[0] = "c_do_create";
    argvar[1] = "neurospaces";
    argvar[2] = "/model_container";

    do_create(3, argvar);

    pnsintegrator->pelNeurospaces
	= (struct neurospaces_type *) GetElement("/model_container");

    if (pnsintegrator->pelNeurospaces == NULL)
    {
	printf("Could not create Model Container\n");
	exit(1);
    }
       
    //- if no model container yet

    if (!pneuro)
    {
	//- create one with an empty model

	char *ppvArgs[] =
	    {
		"genesis-neurospaces-bridge",
		"/usr/local/neurospaces/models/library/utilities/empty_model.ndf",
		"empty_model.ndf",
		NULL,
		NULL,
	    };

	pnsintegrator->pelNeurospaces->pneuro
	    = NeurospacesNewFromCmdLine(2, &ppvArgs[0]);

	if (!pnsintegrator->pelNeurospaces->pneuro)
	{
	    fprintf(stderr, "Error initializing neurospaces model container\n");

	    return -1;
	}
    }

    //- else

    else
    {
	//- link the genesis element with the pre-existing model container

	pnsintegrator->pelNeurospaces->pneuro = pneuro;

	/// \note gosh, I had to do the same hack when integrating neurospaces
	/// \note with genesis2/hsolve.

	struct ParserContext *pacRoot = pneuro->pacRootContext;

	struct ImportedFile *pifRoot = ParserContextGetImportedFile(pacRoot);

	/// \note depending on how the linking is done, there can be multiple
	/// \note instances of neurospaces around.  The following is a hack to
	/// \note enforce the singleton (a bit)

/*        fprintf(stdout, "HeccerConstruct(): root import is %p\n", ImportedFileGetRootImport()); */

	ImportedFileSetRootImport(pifRoot);

/*        fprintf(stdout, "HeccerConstruct(): root import is %p\n", ImportedFileGetRootImport()); */
    }

    //- Now we cache the root context for easier referencing.

    pnsintegrator->ppistCachedRoot = PidinStackParse("/");

    pnsintegrator->phsleCachedRoot = PidinStackLookupTopSymbol(pnsintegrator->ppistCachedRoot);

    //- Initializes the Heccer stuff: array + index.
    //- The heccer array is an array of pointers
    //- to heccer objects.

    pnsintegrator->iModelRegistrations = 0;

    pnsintegrator->psr = (struct SolverRegistration *) calloc(MAX_HECCERS, sizeof(struct SolverRegistration));

    if (!pnsintegrator->psr)
    {
	fprintf(stderr, "Error initializing SolverRegistration storage\n");
	return -1;
    }

    //- Initialize the array for storing the heccer names.
    //- Allocate same number as the amount for heccer pointers.

/*    pnsintegrator->iHeccerNames = 0; */

/*    pnsintegrator->ppcHeccerNames =  */
/*      (char**)calloc(MAX_HECCERS,sizeof(char*)); */


/*    if( !pnsintegrator->ppcHeccerNames ){ */

/*      fprintf(stderr,"Error initializing storage for Heccer names.\n"); */
/*      return -1; */

/*    } */
/*    else */
/*    { */
/*      pnsintegrator->ppcHeccerNames[pnsintegrator->iHeccerNames++] = HARDCODED_ROOT; */
/*    } */

    char *argvar2[5];  

    argvar2[0] = "c_do_create";  
    argvar2[1] = "nsintegrator";  
    argvar2[2] = "/neurospaces_integrator";  

    do_create(3, argvar2);  

    struct nsintegrator_type *pelnsintegrator
	= (struct nsintegrator_type*) GetElement("/neurospaces_integrator");  

    if (!pelnsintegrator)
    {
	fprintf(stderr, "Unable to create Neurospaces Integrator Object\n"); 

	exit(1); 
    } 

    //-----------------------------------------------------------
    //- First set the default heccer dump selection value

    pelnsintegrator->heccer_dump_selection = HECCER_DUMP_ALL;

    pelnsintegrator->heccer_reporting_granularity = 1;

    //------------------------------------------------------------
    //-
    //- Create a heccer for storing default heccer options.
    //- 

    struct simobj_Heccer *pheccer = HeccerNew("Options_Only", NULL, NULL, NULL);

    if (!pheccer)
    {
	fprintf(stderr, "Error allocating Heccer for Context %s\n", "Options_Only");

	return -1;
    }

/*    pheccer->dStep = HECCER_DEFAULT_TIME_STEP;  */

/*    pheccer->ho.dIntervalStart = HECCER_DEFAULT_INTERVAL_START;  */

/*    pheccer->ho.dIntervalEnd = HECCER_DEFAULT_INTERVAL_END;  */

/*    pheccer->ho.dConcentrationGateStart = HECCER_DEFAULT_INTERVAL_END; */

/*    pheccer->ho.dConcentrationGateEnd =  DBL_MAX;  */

/*    pheccer->ho.iIntervalEntries = HECCER_DEFAULT_INTERVAL_ENTRIES;	  */

/*    pheccer->ho.iSmallTableSize = HECCER_DEFAULT_INTERPOL_INTERVAL_ENTRIES; */

    //! Default values are already set for the object when allocated
    //! The defaults are defined in "heccer/heccer.h"

    pnsintegrator->pheccerOptions = pheccer;

    //---------------------------------------------------

    //-
    //- Initialize the message array.
    //-

    pnsintegrator->ppioMsg
	= (struct ioMsg **) calloc(NUMBER_OF_MESSAGES, sizeof(struct ioMsg *));

    pnsintegrator->iIoMsgs = 0;

    if (!pnsintegrator->ppioMsg )
    {
	fprintf(stderr,"Error initializing IO Message storage\n");

	return -1;
    }

    pelnsintegrator->pnsintegrator = pnsintegrator; 

    return 1;
}

