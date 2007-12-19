
#include <float.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "neurospaces_ext.h"

#include "neurospacessetup.h"

#include "neurospaces/querymachine.h"
#include "neurospaces/cell.h"
#include "neurospaces/projectionquery.h"
#include "neurospaces/randomvalue.h"
#include "neurospaces/segment.h"
#include "neurospaces/solverinfo.h"
//#include "neurospaces/solvermapper.h"
#include "neurospaces/symbolvirtual_protos.h"

#include "neurospaces/algorithm.h"
/* #include "neurospaces/modules/serialcell.h" */
/* #include "neurospaces/modules/serialsegment.h" */

#include "../hines/hines_defs.h"
#include "../hines/hines_struct.h"
/* #include "../hines/hines_neurospaces.h" */

#include "../newconn/newconn_struct.h"

#include "../olf/olf_defs.h"


/* //v number of solverinstances created so far */

/* static int iSolverInstances = 0; */

/* static int cellsolver_getsegments */
/* (Hsolve *phsolve, */
/*  struct PidinStack *ppist, */
/*  struct symtab_HSolveListElement *phsle); */

/* static int */
/* populationsolver_getsegments */
/* (Hsolve *phsolve, */
/*  struct PidinStack *ppist, */
/*  struct symtab_HSolveListElement *phsle); */


/* #define NO_INTERP 0 */
/* #define LIN_INTERP 1 */
/* #define FIXED 2 */

/* Golg.* : LIN_INTERP */
/* Gran.* : LIN_INTERP */
/* Purk.* : NO_INTERP */

/* static int */
/* GetSomeDefaultCalcMode(char *pcName) */
/* { */
/*     struct mapping */
/*     { */
/* 	char *pcName; */
/* 	int iCalcMode; */
/*     } */

/*     map[] = */
/*     { */
/* 	{	"Golg",LIN_INTERP, }, */
/* 	{	"Gran",LIN_INTERP, }, */
/* 	{	"Purk",NO_INTERP, }, */
/* 	{	NULL,INT_MAX, }, */
/*     }; */

/*     int i; */

/*     //- if name in table */

/*     for (i = 0 ; map[i].pcName ; i++) */
/*     { */
/* 	if (strncmp(map[i].pcName,pcName,strlen(map[i].pcName)) == 0) */
/* 	{ */
/* 	    //- return entry from table */

/* 	    return(map[i].iCalcMode); */
/* 	} */
/*     } */

/*     //- return default : interpolation */

/*     return(LIN_INTERP); */
/* } */


/* static int  */
/* solver_segmentprocessor */
/* (struct symbolRun *psymr, */
/*  void *pvUserdata) */
/* { */
/*     //- set default result : ok */

/*     int iResult = SYMBOL_PROCESSOR_SUCCESS; */

/*     //- get pointer to solved segments */

/*     struct SolvedCompartments *pscs = (struct SolvedCompartments *)pvUserdata; */

/*     //- set actual symbol */

/*     struct symtab_HSolveListElement *phsle = SymbolRunGetActual(psymr); */

/*     //- if segment */

/*     if (InstanceOfSegment(phsle)) */
/*     { */
/* 	//- register as solved segment without parent */

/* 	int iSegment = pscs->iCompartments; */

/* 	pscs->psc[iSegment].phsle = phsle; */

/* 	pscs->psc[iSegment].ppist */
/* 	    = PidinStackDuplicate(psymr->ppist); */

/* 	//- register no parent */

/* 	pscs->psc[iSegment].iParent = -1; */

/* 	//- increment number of solved segments */

/* 	pscs->iCompartments++; */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


/* struct ProjectionQuery * */
/* NeuroSpacesModelGetProjectionQuery(struct neurospaces_type *pneuro) */
/* { */
/*     //- if projection query not init'd yet */

/*     if (!pneuro->pneuro->ppq) */
/*     { */
/* 	//- initialize projection query */

/* 	struct ProjectionQuery *ppq */
/* 	    = ProjectionQueryCallocFromProjections */
/* 	      (pneuro->pppistProjections,pneuro->iProjections); */

/* 	//- add caching flag. */

/* 	ProjectionQuerySetCaching(ppq,pneuro->bCaching); */

/* 	//- register projection query with neurospaces */

/* 	//! this is usefull for the query machine. */

/* 	NeuroSpacesSetProjectionQuery(pneuro->pneuro,ppq); */
/*     } */

/*     //- return global projection query */

/*     return(pneuro->pneuro->ppq); */
/* } */


/* void NeuroSpacesModelSetupLock(struct neurospaces_type *pneuro) */
/* { */
/*     //! I still need a locking mechanism here to protect access to */
/*     //! globals */

/*     //! bit hacky */

/*     ParserSetContext(pneuro->pneuro->pacRootContext); */

/*     ParserSetRootContext(pneuro->pneuro->pacRootContext); */
/* } */


/* void NeuroSpacesModelSetupUnlock(struct neurospaces_type *pneuro) */
/* { */
/*     //! I still need a locking mechanism here to protect access to */
/*     //! globals */

/*     //! bit hacky */

/*     ParserClearContext(/\* pneuro->pneuro->pacRootContext *\/); */

/*     ParserClearRootContext(/\* pneuro->pneuro->pacRootContext *\/); */
/* } */


/* int neurospacessetup(struct neurospaces_type *pneuro,int argc,char *argv[]) */
/* { */
/*     //- set default result */

/*     int iResult = 0; */

/*     int i; */

/*     int iSolver = -1; */

/*     //v indicates mismatch between symbol type and registered type */

/*     int bMismatch = FALSE; */

/*     struct symtab_HSolveListElement *phsle = NULL; */

/*     //- parse command line element */

/*     struct PidinStack *ppist = PidinStackParse(argv[2]); */

/*     //- lock neurospaces */

/*     NeuroSpacesModelSetupLock(pneuro); */

/*     //- setup solver instance */

/*     NeuroSpacesSetupSolverInstance(pneuro->pneuro,argv[1],ppist); */

/*     //- unlock neurospaces */

/*     NeuroSpacesModelSetupUnlock(pneuro); */

/*     //- free pidinstack */

/*     PidinStackFree(ppist); */

/*     //- return result */

/*     return(iResult); */
/* } */


/* static int cellsolver_getsegments */
/* (Hsolve *phsolve, */
/*  struct PidinStack *ppist, */
/*  struct symtab_HSolveListElement *phsle) */
/* { */
/*     struct symtab_Cell *pcell = (struct symtab_Cell *)phsle; */

/*     int iSegments = CellCountSegments(pcell,ppist); */

/*     int i; */

/*     //- allocate for segments to solve */

/*     phsolve->pscs */
/* 	= (struct SolvedCompartments *) */
/* 	  calloc(1,sizeof(struct SolvedCompartments)); */

/*     phsolve->pscs->iCompartments = 0; //iSegments; */

/*     phsolve->pscs->psc */
/* 	= (struct SolvedCompartment *) */
/* 	  calloc(iSegments,sizeof(struct SolvedCompartment)); */

/*     //- register solved segments in cell */

/*     CellTraverseSegments */
/* 	(phsle,ppist,solver_segmentprocessor,NULL,phsolve->pscs); */

/*     //- loop over all registered segments */

/*     for (i = 0 ; i < iSegments ; i++) */
/*     { */
/* 	//- get pointer to current segment */

/* 	struct symtab_HSolveListElement *phsleComp */
/* 	    = phsolve->pscs->psc[i].phsle; */

/* 	struct PidinStack *ppistComp = phsolve->pscs->psc[i].ppist; */

/* /\* 	//- if parent pidin *\/ */

/* /\* 	struct symtab_IdentifierIndex * pidinParent *\/ */
/* /\* 	    = SegmentGetParentPidin *\/ */
/* /\* 	      ((struct symtab_Segment *)phsleComp); *\/ */

/* /\* 	if (pidinParent) *\/ */
/* 	{ */
/* 	    int j; */

/* 	    struct symtab_Parameters *pparParent */
/* 		= SymbolFindParameter(phsleComp, "PARENT", ppistComp); */

/* 	    struct PidinStack *ppistParent */
/* 		= ParameterResolveToPidinStack(pparParent, ppistComp); */

/* /\* 	    //- construct reference to parent *\/ */

/* /\* 	    struct PidinStack *ppistParent = PidinStackDuplicate(ppistComp); *\/ */

/* /\* 	    //t remove this pop, should always be relative to this symbol *\/ */
/* /\* 	    //t instead of relative to parent symbol for consistency  *\/ */
/* /\* 	    //t reasons with other parameters. *\/ */
/* /\* 	    //t means change to description files to. *\/ */

/* /\* 	    //! pop instruction remove without testing at 02/03/2006, *\/ */
/* /\* 	    //! will convert the purkinje description file in the *\/ */
/* /\* 	    //! neurospaces model library accordingly. *\/ */

/* /\* /\* 	    PidinStackPop(ppistParent); * *\/ */

/* /\* 	    PidinStackPushCompact(ppistParent,pidinParent); *\/ */

/* 	    //- loop over all segments */

/* 	    for (j = 0 ; j < iSegments ; j++) */
/* 	    { */
/* 		//- if same segments */

/* 		if (PidinStackEqual(ppistParent,phsolve->pscs->psc[j].ppist)) */
/* 		{ */
/* 		    //- register parent segment index */

/* 		    //t must be j + 1 ? */

/* 		    phsolve->pscs->psc[i].iParent = j; */

/* 		    //- break searching loop */

/* 		    break; */
/* 		} */
/* 	    } */

/* 	    //- free allocated memory */

/* 	    PidinStackFree(ppistParent); */

/* 	} // if */
/*     } */

/*     return(0); */
/* } */


/* int  */
/* neurospacessetup_cellsolver */
/* (struct NeuroSpaces *pn, */
/*  void *pvUserdata, */
/*  struct symtab_HSolveListElement *phsle, */
/*  struct PidinStack *ppist) */
/* { */
/*     //- set default result : ok */

/*     int iResult = 0; */

/*     //- get pointer to original element */

/*     struct neurospaces_type *pneuro */
/* 	= (struct neurospaces_type *)pvUserdata; */

/*     char	*argvar[5]; */
/*     Hsolve	*phsolve; */
/*     int		i; */

/*     char pcCell[100]; */

/*     //- create hsolve element */

/*     //! remember that do_create() can modify the name of the element to create */

/*     sprintf(pcCell, "%i-%s-cell", iSolverInstances, SymbolName(phsle)); */

/*     iSolverInstances++; */

/*     argvar[0] = "c_do_create"; */
/*     argvar[1] = "hsolve"; */
/*     argvar[2] = pcCell; */

/*     do_create(3,argvar); */
 
/*     //- get pointer to hines solver */

/*     phsolve = (Hsolve *)GetElement(argvar[2]); */

/*     //- register pathname of neurospaces model */

/*     phsolve->pcNeuroSpaces = CopyString(Pathname((Element *)pneuro)); */

/*     //- set flag : created from neurospaces model */

/*     phsolve->readflag = HNEUROSPACES_MODEL_T; */

/*     //- default : apply chanmode 5, with some default calc mode */

/*     phsolve->chanmode = 5; */
/*     phsolve->calcmode = GetSomeDefaultCalcMode(pcCell); */

/*     //- reasonable default time step */

/*     phsolve->dt = 2e-5; */

/*     //- set neurospaces context of solved cell */

/*     phsolve->ppistContext = PidinStackDuplicate(ppist); */

/*     //- get segments to solve */

/*     iResult = cellsolver_getsegments(phsolve,ppist,phsle); */

/*     //- if ok */

/*     if (iResult == 0) */
/*     { */
/* 	//- setup hines solver */

/* 	iResult = NeuroSpacesSolveSetupFromCellModel(phsolve,ppist); */
/*     } */

/*     //- if ok */

/*     if (iResult == 0) */
/*     { */
/* 	//- register solver for this symbol */

/* 	SolverInfoRegistrationAddFromContext(NULL,ppist,Pathname(phsolve)); */
/*     } */
/*     else */
/*     { */
/* 	//t delete solver ? */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


/* static int */
/* populationsolver_getsegments */
/* (Hsolve *phsolve, */
/*  struct PidinStack *ppist, */
/*  struct symtab_HSolveListElement *phsle) */
/* { */
/*     struct symtab_Population *ppopu = (struct symtab_Population *)phsle; */

/*     int iSegments = PopulationCountSegments(ppopu,ppist); */

/*     int i; */

/*     //- allocate for segments to solve */

/*     phsolve->pscs */
/* 	= (struct SolvedCompartments *) */
/* 	  calloc(1,sizeof(struct SolvedCompartments)); */

/*     phsolve->pscs->iCompartments = 0; //iSegments; */

/*     phsolve->pscs->psc */
/* 	= (struct SolvedCompartment *) */
/* 	  calloc(iSegments,sizeof(struct SolvedCompartment)); */

/*     //- register solved segments in population */

/*     PopulationTraverseSegments */
/* 	(phsle,ppist,solver_segmentprocessor,NULL,phsolve->pscs); */

/*     return(0); */
/* } */


/* int  */
/* neurospacessetup_populationsolver */
/* (struct NeuroSpaces *pn, */
/*  void *pvUserdata, */
/*  struct symtab_HSolveListElement *phsle, */
/*  struct PidinStack *ppist) */
/* { */
/*     //- set default result : ok */

/*     int iResult = 0; */

/*     //- get pointer to original element */

/*     struct neurospaces_type *pneuro */
/* 	= (struct neurospaces_type *)pvUserdata; */

/*     char	*argvar[5]; */
/*     Hsolve	*phsolve; */

/*     char pcPopulation[100]; */

/*     //- create hsolve array */

/*     //! remember that do_create() can modify the name of the element to create */

/*     sprintf(pcPopulation, "%i-%s-population", iSolverInstances, SymbolName(phsle)); */

/*     iSolverInstances++; */

/*     argvar[0] = "c_do_create"; */
/*     argvar[1] = "hsolvearray"; */
/*     argvar[2] = pcPopulation; */

/*     do_create(3,argvar); */
 
/*     //- get pointer to hines solver */

/*     phsolve = (Hsolve *)GetElement(argvar[2]); */

/*     //- register pathname of neurospaces model */

/*     phsolve->pcNeuroSpaces = CopyString(Pathname((Element *)pneuro)); */

/*     //- set flag : created from neurospaces model */

/*     phsolve->readflag = HNEUROSPACES_MODEL_T; */

/*     //- default : apply chanmode 5, with some default calc mode */

/*     phsolve->chanmode = 5; */
/*     phsolve->calcmode = GetSomeDefaultCalcMode(pcPopulation); */

/*     //- reasonable default time step */

/*     phsolve->dt = 2e-5; */

/*     //- set neurospaces context of solved population */

/*     phsolve->ppistContext = PidinStackDuplicate(ppist); */

/*     //- get segments to solve */

/*     iResult = populationsolver_getsegments(phsolve,ppist,phsle); */

/*     //- if ok */

/*     if (iResult == 0) */
/*     { */
/* 	//- setup population solver */

/* 	iResult = NeuroSpacesSolveSetupFromPopulationModel(phsolve,ppist); */
/*     } */

/*     //- if ok */

/*     if (iResult == 0) */
/*     { */
/* 	//- register solver for this symbol */

/* 	SolverInfoRegistrationAddFromContext(NULL,ppist,Pathname(phsolve)); */
/*     } */
/*     else */
/*     { */
/* 	//t delete solver ? */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


/* int  */
/* neurospacessetup_projection */
/* (struct NeuroSpaces *pn, */
/*  void *pvUserdata, */
/*  struct symtab_HSolveListElement *phsle, */
/*  struct PidinStack *ppist) */
/* { */
/*     //- set default result : ok */

/*     int iResult = 0; */

/*     //- get pointer to original element */

/*     struct neurospaces_type *pneuro */
/* 	= (struct neurospaces_type *)pvUserdata; */

/*     //- if room available */

/*     if (pneuro->iProjections < MAX_NUM_OF_PROJECTIONS) */
/*     { */
/* 	//- duplicate pidinstack */

/* 	struct PidinStack *ppistDuplicate = PidinStackDuplicate(ppist); */

/* 	//- add to projections to query */

/* 	pneuro->pppistProjections[pneuro->iProjections] = ppistDuplicate; */

/* 	pneuro->iProjections++; */
/*     } */

/*     //- else */

/*     else */
/*     { */
/* 	//- diag's */

/* 	fprintf */
/* 	    (stdout,"%s : Too many projections in query\n",Pathname(pneuro)); */

/* 	//- set result : failure */

/* 	iResult = 1; */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


/* int  */
/* neurospacessetup_randomspike */
/* (struct NeuroSpaces *pn, */
/*  void *pvUserdata, */
/*  struct symtab_HSolveListElement *phsle, */
/*  struct PidinStack *ppist) */
/* { */
/*     //- set default result : ok */

/*     int iResult = 0; */

/*     //- get pointer to original element */

/*     struct neurospaces_type *pneuro */
/* 	= (struct neurospaces_type *)pvUserdata; */

/*     char	*argvar[25]; */
/*     struct Randomspike_type *pranspk = NULL; */
/*     struct Spikegen_type *pspkgen = NULL; */
/*     int		i; */

/*     char pcBase[100]; */

/*     char pcRandomSpike[100]; */

/*     char pcSpikeGen[100]; */

/*     char pcRandomSpikeStore[100]; */

/*     char pcSpikeGenStore[100]; */

/*     char ppcCommands[10][20]; */

/*     struct symtab_Parameters *pparRate = NULL; */
/*     double dRate; */

/*     struct symtab_Parameters *pparRefr = NULL; */
/*     double dRefr; */

/*     //- get name of randomspike */

/*     sprintf(pcBase, "%i-%s-randomvalue", iSolverInstances, SymbolName(phsle)); */

/*     iSolverInstances++; */

/*     //- get parameters */

/*     pparRate = SymbolGetParameter(phsle,"RATE",ppist); */
/*     dRate = pparRate ? ParameterResolveValue(pparRate,ppist) : FLT_MAX ; */

/*     pparRefr = SymbolGetParameter(phsle,"REFRACTORY",ppist); */
/*     dRefr = pparRefr ? ParameterResolveValue(pparRefr,ppist) : FLT_MAX ; */

/*     //- if problems with parameters */

/*     if (dRate == FLT_MAX || dRefr == FLT_MAX) */
/*     { */
/* 	//- give diagnostics */

/* 	fprintf */
/* 	    (stdout, */
/* 	     "Problems with parameters : RATE = %f, REFRACTORY = %f\n", */
/* 	     dRate, */
/* 	     dRefr); */

/* 	//- return failure */

/* 	return(1); */
/*     } */

/*     //- create randomspike element */

/*     strcpy(pcRandomSpikeStore, pcBase); */

/*     strcpy(pcRandomSpike, pcRandomSpikeStore); */

/*     argvar[0] = "c_do_create"; */
/*     argvar[1] = "randomspike"; */
/*     argvar[2] = pcRandomSpike; */

/*     //! remember that do_create() can modify the name of the element to create */

/*     do_create(3,argvar); */

/*     pranspk = (struct Randomspike_type *)GetElement(pcRandomSpike); */

/*     if (!pranspk) */
/*     { */
/* 	return(1); */
/*     } */

/*     //- register pathname of neurospaces model */

/*     pranspk->pcNeuroSpaces = CopyString(Pathname((Element *)pneuro)); */

/*     //- set neurospaces context of solved symbols */

/*     pranspk->ppistContext = PidinStackDuplicate(ppist); */

/*     //- create spikegen */

/*     strcpy(pcSpikeGenStore, pcBase); */

/*     strcat(pcSpikeGenStore, "/"); */

/*     strcat(pcSpikeGenStore, SymbolName(RandomvalueGetSpikeGenerator(phsle, ppist))); */

/*     strcpy(pcSpikeGen, pcSpikeGenStore); */

/*     argvar[0] = "c_do_create"; */
/*     argvar[1] = "spikegen"; */
/*     argvar[2] = pcSpikeGen; */

/*     //! remember that do_create() can modify the name of the element to create */

/*     do_create(3,argvar); */

/*     strcpy(pcSpikeGen, pcSpikeGenStore); */

/*     pspkgen = (struct Spikegen_type *)GetElement(pcSpikeGen); */

/*     if (!pspkgen) */
/*     { */
/* 	return(1); */
/*     } */

/*     //- register pathname of neurospaces model */

/*     pspkgen->pcNeuroSpaces = CopyString(Pathname((Element *)pneuro)); */

/*     //- set neurospaces context of solved symbols */

/*     pspkgen->ppistContext = PidinStackDuplicate(ppist); */

/*     //- set fields for randomspike */

/*     strcpy(pcRandomSpike, pcRandomSpikeStore); */

/*     sprintf(ppcCommands[0],"%f",dRate); */
/*     sprintf(ppcCommands[1],"%f",dRefr); */

/*     argvar[0] = "c_do_set"; */
/*     argvar[1] = pcRandomSpike; */
/*     argvar[2] = "rate"; */
/*     argvar[3] = ppcCommands[0]; */
/*     argvar[4] = "abs_refract"; */
/*     argvar[5] = ppcCommands[1]; */
/*     argvar[6] = "reset"; */
/*     argvar[7] = "1"; */
/*     argvar[8] = NULL; */

/*     if (do_set(8,argvar) != 1) */
/*     { */
/* 	iResult = 1; */
/*     } */

/*     //- set fields of spikegen */

/*     strcpy(pcSpikeGen, pcSpikeGenStore); */

/*     argvar[0] = "c_do_set"; */
/*     argvar[1] = pcSpikeGen; */
/*     argvar[2] = "abs_refract"; */
/*     argvar[3] = ppcCommands[1]; */
/*     argvar[4] = "thresh"; */
/*     argvar[5] = "0.5"; */
/*     argvar[6] = NULL; */

/*     if (do_set(6,argvar) != 1) */
/*     { */
/* 	iResult = 1; */
/*     } */

/*     //- link randomspike to spikegen with msg */

/*     strcpy(pcRandomSpike, pcRandomSpikeStore); */

/*     strcpy(pcSpikeGen, pcSpikeGenStore); */

/*     argvar[0] = "c_do_add_msg"; */
/*     argvar[1] = pcRandomSpike; */
/*     argvar[2] = pcSpikeGen; */
/*     argvar[3] = "INPUT"; */
/*     argvar[4] = "state"; */
/*     argvar[5] = NULL; */

/*     if (do_add_msg(5,argvar) != 1) */
/*     { */
/* 	iResult = 1; */
/*     } */

/*     //- if ok */

/*     if (iResult == 0) */
/*     { */
/* 	//- register solver for this symbol */

/* 	SolverInfoRegistrationAddFromContext(NULL,ppist,Pathname(pranspk)); */
/*     } */
/*     else */
/*     { */
/* 	//t delete solver (== randomspike) ? */
/*     } */

/*     //- return result */

/*     return(iResult); */
/* } */


