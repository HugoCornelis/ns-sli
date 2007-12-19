

#include "neurospaces_ext.h"

#include "neurospacesquery.h"
#include "neurospaces/pidinstack.h"
#include "neurospaces/querymachine.h"
#include "neurospaces/solverinfo.h"

#include "../hines/hines_struct.h"
/* #include "../hines/hines_neurospaces.h" */


int neurospacesquery(struct neurospaces_type *pneuro)
{
    //- if neurospaces initialized

    if (pneuro->pneuro)
    {
	//- set global parameters for current model

	//! bit hacky

	ParserSetContext(pneuro->pneuro->pacRootContext);

	ParserSetRootContext(pneuro->pneuro->pacRootContext);
    }

    //- start query machine

    QueryMachineStart(pneuro->pneuro, 1);

    //- if neurospaces initialized

    if (pneuro->pneuro)
    {
	//- clear global parameters for current model

	//! bit hacky

	ParserClearContext(/* pneuro->pneuro->pacRootContext */);

	ParserClearRootContext(/* pneuro->pneuro->pacRootContext */);
    }

    //- return

    return(0);
}


/* char *solver_element_info(argc,argv) */
/*     int argc; */
/*     char **argv; */
/* { */
/*     //- set default result : none */

/*      char *pcResult = NULL; */

/*     struct neurospaces_type *pneuro = NULL; */
/*     struct PidinStack *ppist = NULL; */
/*     struct symtab_HSolveListElement *phsle = NULL; */
/*     struct SolverInfo *psi = NULL; */
/*     const char *pcSolver = NULL; */

/*     //- init opt library */

/*     initopt(argc,argv,"neurospaces element field"); */

/*     //- if wrong options are given */

/*     if (G_getopt(argc,argv) != 0) */
/*     { */
/* 	//- print usage */

/* 	printoptusage(argc,argv); */

/* 	//- return default result */

/* 	return(pcResult); */
/*     } */

/*     //- get pointer to neurospaces */

/*     pneuro = (struct neurospaces_type *)GetElement(optargv[1]); */

/*     if (!pneuro */
/* 	|| strcmp(BaseObject(pneuro)->name,"neurospaces") != 0) */
/*     { */
/* 	Error(); */
/* 	printf(" %s should be neurospaces\n",optargv[1]); */
/* 	return(pcResult); */
/*     } */

/*     //- set global parameters for current model */

/*     //! bit hacky */

/*     ParserSetContext(pneuro->pneuro->pacRootContext); */

/*     ParserSetRootContext(pneuro->pneuro->pacRootContext); */

/*     //- parse symbol */

/*     ppist = PidinStackParse(optargv[2]); */

/*     //- lookup symbol */

/*     phsle = SymbolsLookupHierarchical(pneuro->pneuro->psym,ppist); */

/*     if (!phsle) */
/*     { */
/* 	Error(); */
/* 	printf(" %s not found in neurospaces\n",optargv[2]); */

/* 	//- clear global parameters for current model */

/* 	//! bit hacky */

/* 	ParserClearContext(/\* pneuro->pneuro->pacRootContext *\/); */

/* 	ParserClearRootContext(/\* pneuro->pneuro->pacRootContext *\/); */

/* 	//- free context */

/* 	PidinStackFree(ppist); */

/* 	return(pcResult); */
/*     } */

/*     //- if projection */

/*     if (InstanceOfProjection(phsle)) */
/*     { */
/* 	//- diag's */

/* 	Error(); */
/* 	fprintf(stdout,"not implemented for projections\n"); */
/*     } */

/*     //- if instance of biocomponent */

/*     else if (InstanceOfBioComponent(phsle)) */
/*     { */
/* 	//- get solver info for symbol */

/* 	psi = SolverInfoRegistrationGet(NULL,ppist); */

/* 	if (!psi) */
/* 	{ */
/* 	    Error(); */

/* 	    fprintf(stdout,"Could not find solver info\n"); */

/* 	    //- clear global parameters for current model */

/* 	    //! bit hacky */

/* 	    ParserClearContext(/\* pneuro->pneuro->pacRootContext *\/); */

/* 	    ParserClearRootContext(/\* pneuro->pneuro->pacRootContext *\/); */

/* 	    //- free context */

/* 	    PidinStackFree(ppist); */

/* 	    return(pcResult); */
/* 	} */

/* 	//- get solver reference */

/* 	pcSolver = SolverInfoGetSolver(psi); */

/* 	//- diag's */

/* 	fprintf(stdout,"Solver = %s\n",pcSolver); */

/* 	//- set result */

/* 	pcResult = CopyString(pcSolver); */
/*     } */

/*     //- clear global parameters for current model */

/*     //! bit hacky */

/*     ParserClearContext(/\* pneuro->pneuro->pacRootContext *\/); */

/*     ParserClearRootContext(/\* pneuro->pneuro->pacRootContext *\/); */

/*     //- free context */

/*     PidinStackFree(ppist); */

/*     //- return result */

/*     return(pcResult); */
/* } */


/* char *solver_field_info(argc,argv) */
/*     int argc; */
/*     char **argv; */
/* { */
/*     //- set default result : none */

/*     char *pcResult = NULL; */

/*     struct neurospaces_type *pneuro = NULL; */
/*     struct PidinStack *ppist = NULL; */
/*     struct symtab_HSolveListElement *phsle = NULL; */
/*     int iSerialID = -1; */
/*     struct SolverInfo *psi = NULL; */
/*     const char *pcSolver = NULL; */

/*     //- init opt library */

/*     initopt(argc,argv,"neurospaces element field"); */

/*     //- if wrong options are given */

/*     if (G_getopt(argc,argv) != 0) */
/*     { */
/* 	//- print usage */

/* 	printoptusage(argc,argv); */

/* 	//- return default result */

/* 	return(pcResult); */
/*     } */

/*     //- get pointer to neurospaces */

/*     pneuro = (struct neurospaces_type *)GetElement(optargv[1]); */

/*     if (!pneuro */
/* 	|| strcmp(BaseObject(pneuro)->name,"neurospaces") != 0) */
/*     { */
/* 	Error(); */
/* 	printf(" %s should be neurospaces\n",optargv[1]); */
/* 	return(pcResult); */
/*     } */

/*     //- set global parameters for current model */

/*     //! bit hacky */

/*     ParserSetContext(pneuro->pneuro->pacRootContext); */

/*     ParserSetRootContext(pneuro->pneuro->pacRootContext); */

/*     //- parse symbol */

/*     ppist = PidinStackParse(optargv[2]); */

/*     //- lookup symbol */

/*     phsle = SymbolsLookupHierarchical(pneuro->pneuro->psym,ppist); */

/*     if (!phsle) */
/*     { */
/* 	Error(); */
/* 	printf(" %s not found in neurospaces\n",optargv[2]); */

/* 	//- clear global parameters for current model */

/* 	//! bit hacky */

/* 	ParserClearContext(/\* pneuro->pneuro->pacRootContext *\/); */

/* 	ParserClearRootContext(/\* pneuro->pneuro->pacRootContext *\/); */

/* 	//- free context */

/* 	PidinStackFree(ppist); */

/* 	return(pcResult); */
/*     } */

/*     //- if projection */

/*     if (InstanceOfProjection(phsle)) */
/*     { */
/* 	//- diag's */

/* 	Error(); */
/* 	fprintf(stdout,"not implemented for projections\n"); */
/*     } */

/*     //- if instance of biocomponent */

/*     else if (InstanceOfBioComponent(phsle)) */
/*     { */
/* 	//- get solver info for symbol */

/* 	psi = SolverInfoRegistrationGet(NULL,ppist); */

/* 	if (!psi) */
/* 	{ */
/* 	    Error(); */

/* 	    fprintf(stdout,"Could not find solver info\n"); */

/* 	    //- clear global parameters for current model */

/* 	    //! bit hacky */

/* 	    ParserClearContext(/\* pneuro->pneuro->pacRootContext *\/); */

/* 	    ParserClearRootContext(/\* pneuro->pneuro->pacRootContext *\/); */

/* 	    //- free context */

/* 	    PidinStackFree(ppist); */

/* 	    return(pcResult); */
/* 	} */

/* 	//- get principal serial for symbol relative to solver */

/* 	iSerialID = SolverInfoLookupPrincipalSerial(psi,ppist); */

/* 	//- get solver reference */

/* 	pcSolver = SolverInfoGetSolver(psi); */

/* 	//- diag's */

/* 	fprintf(stdout,"Solver = %s, serial ID = %i\n",pcSolver,iSerialID); */
/*     } */

/*     //- if serial ID found */

/*     if (iSerialID != -1) */
/*     { */
/* 	//- find solver */

/* 	Hsolve *phsolve = (Hsolve *)GetElement(pcSolver); */

/* 	//- request solver field from solution engine */

/* 	pcResult */
/* 	    = NeuroSpacesSolveRequestSolverField */
/* 	      (phsolve,psi,iSerialID,optargv[3]); */
/*     } */

/*     //- clear global parameters for current model */

/*     //! bit hacky */

/*     ParserClearContext(/\* pneuro->pneuro->pacRootContext *\/); */

/*     ParserClearRootContext(/\* pneuro->pneuro->pacRootContext *\/); */

/*     //- free context */

/*     PidinStackFree(ppist); */

/*     //- return result */

/*     return(pcResult); */
/* } */


