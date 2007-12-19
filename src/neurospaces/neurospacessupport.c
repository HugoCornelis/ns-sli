

#include "neurospacessupport.h"

/* #include "../hines/hines_defs.h" */

//#include "neurospaces/alias.h"
#include "neurospaces/attachment.h"
#include "neurospaces/channel.h"

/* #include "neurospaces/channelvirtual_protos.h" */
#include "neurospaces/symbolvirtual_protos.h"
#include "hierarchy/output/symbols/type_defines.h"


/// **************************************************************************
///
/// SHORT: NeuroSpacesModelSymbol2SolverType()
///
/// ARGS.:
///
///	phsle......: symbol to convert
///	piTypes....: solver childs receiving result
///	piChildren.: number of solver childs, receiving result
///
/// RTN..: int : 0 : success, < 0 : failure
///
///	piTypes....: solver childs receiving result
///	piChildren.: number of solver childs, receiving result
///
/// DESCR: Translate a model symbol to solver symbols
///
///	Fits following purposes (not all implemented) :
///
///	1. Count number of solver children associated with this symbol
///	2. Translate symbol to solver children
///	3. Check if solvability of this symbol (e.g. synchans must have
///		exp2 equation, GHK can't be solved at the moment,...)
///
/// NOTE:
///
///	Signature of this proc. should have a context stack. It can be
///	necessary to have multiple solver children for NERNST_T depending
///	on the parameters of the nernst. To check the parameters we need a
///	context.
///
/// **************************************************************************

/* int */
/* NeuroSpacesModelSymbol2SolverType */
/* (struct symtab_HSolveListElement *phsle, */
/*  struct PidinStack *ppist, */
/*  short *piTypes, */
/*  int *piChildren) */
/* { */
/*     //- set default result : success */

/*     int bResult = 0; */

/*     //v number of children, if *piChildren present always equal */

/*     int iChildren = 0; */

/*     if (piChildren) */
/*     { */
/* 	*piChildren = iChildren; */
/*     } */

/*     //- look at symbol type */

/*     switch(phsle->iType) */
/*     { */
/* /\* */
/*     //- for TYPE_HSLE_SEGMENT */
/*     //- for TYPE_HSLE_D3SEGMENT */

/*     case TYPE_HSLE_SEGMENT: */
/*     case TYPE_HSLE_D3SEGMENT: */
/*     { */
/* 	//- result is COMPT_T */

/* 	//! children count should be zero */

/* 	iResult = COMPT_T; */

/* 	break; */
/*     } */
/* *\/ */

/*     //- for TYPE_HSLE_CELL */

/*     case HIERARCHY_TYPE_symbols_cell: */
/*     { */
/* 	//- ok : nothing to do */

/* 	break; */
/*     } */

/*     //- for TYPE_HSLE_CHANNEL */

/*     case HIERARCHY_TYPE_symbols_channel: */
/*     { */
/* 	//- if can receive spikes */

/* 	//if (SymbolReceivesSpikes(phsle,ppist)) */

/* 	//t changed this check into equation check, having an equation does */
/* 	//t not mean that it can receive spikes, should be changed. */

/* 	if (ChannelHasEquation((struct symtab_Channel *)phsle,ppist)) */
/* 	{ */
/* 	    //! must be synchan */
/* 	    //! check for frequency field delayed to later time, */
/* 	    //!   when ops[] is filled */

/* 	    //- add one child */

/* 	    iChildren++; */

/* 	    if (piChildren) */
/* 	    { */
/* 		*piChildren = iChildren; */
/* 	    } */

/* 	    //- fill entry : synchan */

/* 	    if (piTypes) */
/* 	    { */
/* 		piTypes[iChildren - 1] = SYNCHANC_T; */
/* 	    } */

/* 	    //t check for exp2 equation, if something else, warn user */
/* 	    //t that it cannot be solved */

/* 	    //- if channel has nernst equation */

/* 	    if (SymbolHasNernstEk(phsle,ppist)) */
/* 	    { */
/* 		//- add one child */

/* 		iChildren++; */

/* 		if (piChildren) */
/* 		{ */
/* 		    *piChildren = iChildren; */
/* 		} */

/* 		//- fill extra entry : nernst */

/* 		if (piTypes) */
/* 		{ */
/* 		    piTypes[iChildren - 1] = NERNST_T; */
/* 		} */
/* 	    } */

/* 	    //- if channel has MG blocking */

/* 	    if (SymbolHasMGBlockGk(phsle,ppist)) */
/* 	    { */
/* 		//- add one child */

/* 		iChildren++; */

/* 		if (piChildren) */
/* 		{ */
/* 		    *piChildren = iChildren; */
/* 		} */

/* 		//- fill extra entry : MG block */

/* 		if (piTypes) */
/* 		{ */
/* 		    piTypes[iChildren - 1] = MGBLOCK_T; */
/* 		} */
/* 	    } */

/* // how to make distinction between these ? Necessary ? */

/* //#define SYNCHAN_T 3 */
/* //#define CHANC2_T 30 */
/* //#define CHANC3_T 31 */
/* //#define SYNCHANC_T 32 */

/* 	} */

/* 	//- else (no synchan) */

/* 	else */
/* 	{ */
/* 	    //- if tabchan */

/* 	    struct descr_genesis_object *pgenObject */
/* 		= ChannelGetGenesisObject((struct symtab_Channel *)phsle); */

/* 	    if (pgenObject) */
/* 	    { */
/* 		//- look at type of genesis object */

/* 		int ttype = pgenObject->iType; */

/* 		switch (ttype) */
/* 		{ */

/* 		//- for single dimensional table */

/* 		case CHANNEL_TYPE_SINGLE_TABLE: */
/* 		{ */
/* 		    //- default : one child */

/* 		    iChildren = 1; */

/* 		    if (piChildren) */
/* 		    { */
/* 			*piChildren = iChildren; */
/* 		    } */

/* 		    //- fill first entry : tabchan */

/* 		    if (piTypes) */
/* 		    { */
/* 			piTypes[iChildren - 1] = TABCHAN_T; */
/* 		    } */

/* 		    //- if channel has nernst equation */

/* 		    if (SymbolHasNernstEk(phsle,ppist)) */
/* 		    { */
/* 			//- add one child */

/* 			iChildren++; */

/* 			if (piChildren) */
/* 			{ */
/* 			    *piChildren = iChildren; */
/* 			} */

/* 			//- fill extra entry : nernst */

/* 			if (piTypes) */
/* 			{ */
/* 			    piTypes[iChildren - 1] = NERNST_T; */
/* 			} */
/* 		    } */

/* 		    //- if channel has MG blocking */

/* 		    if (SymbolHasMGBlockGk(phsle,ppist)) */
/* 		    { */
/* 			//- add one child */

/* 			iChildren++; */

/* 			if (piChildren) */
/* 			{ */
/* 			    *piChildren = iChildren; */
/* 			} */

/* 			//- fill extra entry : MG block */

/* 			if (piTypes) */
/* 			{ */
/* 			    piTypes[iChildren - 1] = MGBLOCK_T; */
/* 			} */
/* 		    } */

/* 		    break; */
/* 		} */

/* 		//- for two dimensional table */

/* 		case CHANNEL_TYPE_DOUBLE_TABLE: */
/* 		{ */
/* 		    //- default : one child */

/* 		    iChildren = 1; */

/* 		    if (piChildren) */
/* 		    { */
/* 			*piChildren = iChildren; */
/* 		    } */

/* 		    //- fill first entry : tab2chan */

/* 		    if (piTypes) */
/* 		    { */
/* 			piTypes[iChildren - 1] = TAB2CHAN_T; */
/* 		    } */

/* 		    //- if channel has nernst equation */

/* 		    if (SymbolHasNernstEk(phsle,ppist)) */
/* 		    { */
/* 			//- add one child */

/* 			iChildren++; */

/* 			if (piChildren) */
/* 			{ */
/* 			    *piChildren = iChildren; */
/* 			} */

/* 			//- fill extra entry : nernst */

/* 			if (piTypes) */
/* 			{ */
/* 			    piTypes[iChildren - 1] = NERNST_T; */
/* 			} */
/* 		    } */

/* 		    //- if channel has MG blocking */

/* 		    if (SymbolHasMGBlockGk(phsle,ppist)) */
/* 		    { */
/* 			//- add one child */

/* 			iChildren++; */

/* 			if (piChildren) */
/* 			{ */
/* 			    *piChildren = iChildren; */
/* 			} */

/* 			//- fill extra entry : MG block */

/* 			if (piTypes) */
/* 			{ */
/* 			    piTypes[iChildren - 1] = MGBLOCK_T; */
/* 			} */
/* 		    } */

/* 		    break; */
/* 		} */

/* 		case CHANNEL_TYPE_CURRENT: */
/* 		{ */
/* 		    //- give diagnostics */

/* 		    fprintf */
/* 			(stdout, */
/* 			 "NeuroSpacesModelSymbol2SolverType: " */
/* 			 "Failed conversion for CHANNEL_TYPE_CURRENT\n", */
/* 			 phsle->iType, */
/* 			 SymbolHSLETypeDescribe(phsle->iType)); */

/* 		    break; */
/* 		} */
/* 		} */
/* 	    } */

/* 	    //- else */

/* 	    else */
/* 	    { */
/* 		//- give diagnostics */

/* 		fprintf */
/* 		    (stdout, */
/* 		     "NeuroSpacesModelSymbol2SolverType: " */
/* 		     "Failed conversion for %s\n", */
/* 		     IdinName(SymbolGetPidin(phsle))); */

/* 		break; */
/* 	    } */
/* 	} */
/* 	break; */
/*     } */

/*     //- for TYPE_HSLE_EQUATION */

/*     case HIERARCHY_TYPE_symbols_equation: */
/*     { */
/* 	//- ok : nothing to do */

/* 	break; */
/*     } */

/*     //- for TYPE_HSLE_POOL */

/*     case HIERARCHY_TYPE_symbols_pool: */
/*     { */
/* 	//- one child */

/* 	iChildren = 1; */

/* 	if (piChildren) */
/* 	{ */
/* 	    *piChildren = iChildren; */
/* 	} */

/* 	//- fill types array : concen */

/* 	if (piTypes) */
/* 	{ */
/* 	    piTypes[iChildren - 1] = CACONCEN_T; */
/* 	} */
/* 	break; */
/*     } */

/*     //- for TYPE_HSLE_VECTOR_SEGMENT */

/*     case HIERARCHY_TYPE_symbols_v_segment: */
/*     { */
/* 	//- vector of segments : sign as unnecessary child */

/* 	iChildren = 0; */

/* 	if (piChildren) */
/* 	{ */
/* 	    *piChildren = iChildren; */
/* 	} */
/* 	break; */
/*     } */

/*     //- for TYPE_HSLE_ATTACHMENT */

/*     case HIERARCHY_TYPE_symbols_attachment: */
/*     { */
/* 	//- if incoming */

/* 	if (AttachmentPointIsIncoming((struct symtab_Attachment *)phsle)) */
/* 	{ */
/* 	    //- sign as unnecessary child */

/* 	    //! is handled with synchans */

/* 	    iChildren = 0; */

/* 	    if (piChildren) */
/* 	    { */
/* 		*piChildren = iChildren; */
/* 	    } */
/* 	} */
/* 	else if (AttachmentPointIsOutgoing((struct symtab_Attachment *)phsle)) */
/* 	{ */
/* 	    //- one child */

/* 	    iChildren = 1; */

/* 	    if (piChildren) */
/* 	    { */
/* 		*piChildren = iChildren; */
/* 	    } */

/* 	    //- fill types array : steps required for spike operation */

/* 	    if (piTypes) */
/* 	    { */
/* 		piTypes[iChildren - 1] = SPIKEGEN_T; */
/* 	    } */
/* 	} */
/* 	break; */
/*     } */

/*     //- for non-supported types */

/*     default: */
/*     { */
/* 	//- give diagnostics */

/* 	fprintf */
/* 	    (stdout, */
/* 	     "NeuroSpacesModelSymbol2SolverType: " */
/* 	     "Failed conversion for %i == %s\n", */
/* 	     phsle->iType, */
/* 	     SymbolHSLETypeDescribe(phsle->iType)); */
/*     } */
/*     } */

/*     //- return result */

/*     return(bResult); */
/* } */


