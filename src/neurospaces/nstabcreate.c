//------------------------------------------------------------------
/*!
 *  \file nstabcreate.c
 *  \author Mando Rodriguez
 *
 *  This file contains functions for creating a tabchannel object
 *  
 * 
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "shell_func_ext.h"


#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"

#include "nsintegrator.h"




//------------------------------------------------------------------
/*
 *  \fn int NSTabCreate(int argc, char **argv)
 *  \param argc Number of tokens in argv
 *  \param argv Array of pointers to chars
 *  \return 0 on error, 1 on success.
 */
//------------------------------------------------------------------
int NSTabCreate(int argc, char **argv)
{
    if (argc < 4)
    {
	Error();

	printf("usage : %s field xdivs xmin xmax\n", "tabcreate");

	return(0);
    }

    char *pcName = argv[1];
    char *pcField = argv[3];

    int iXdivs = atoi(argv[4]);

    double dXmin = Atod(argv[5]);
    double dXmax = Atod(argv[6]);

    //- get access to the gates

    struct PidinStack * ppistA = getGateContext(pcName, pcField, "A");

    struct PidinStack * ppistB = getGateContext(pcName, pcField, "B");

    struct symtab_HSolveListElement * phsleA = PidinStackLookupTopSymbol(ppistA);

    struct symtab_HSolveListElement * phsleB = PidinStackLookupTopSymbol(ppistB);

    //- if they are not created yet

    if (!phsleA || !phsleB)
    {
	//- set the power field to create the gates

	struct PidinStack * ppistChannel = getRootedContext(pcName);

	struct symtab_HSolveListElement *phsleChannel = PidinStackLookupTopSymbol(ppistChannel);

	char pcPower[100];

	sprintf(pcPower, "%spower", pcField);

	ChannelSetField(phsleChannel, ppistChannel, pcName, pcPower, "99");

	phsleA = PidinStackLookupTopSymbol(ppistA);

	phsleB = PidinStackLookupTopSymbol(ppistB);

	if (!phsleA || !phsleB)
	{
	    Error();

	    printf("TABCREATE Error: cannot find gate kinetic elements for %s\n", pcName);

	    return 0;
	}
    }

    //- set X dimensions of the tables that are to be created

    struct symtab_Parameters *pparTableStartA
	= SymbolSetParameterDouble(phsleA, "HH_TABLE_START", dXmin);

    struct symtab_Parameters *pparTableEndA
	= SymbolSetParameterDouble(phsleA, "HH_TABLE_END", dXmax);

    struct symtab_Parameters *pparTableStepA
	= SymbolSetParameterDouble(phsleA, "HH_TABLE_STEP", (double)iXdivs);

    struct symtab_Parameters *pparTableStartB
	= SymbolSetParameterDouble(phsleB, "HH_TABLE_START", dXmin);

    struct symtab_Parameters *pparTableEndB
	= SymbolSetParameterDouble(phsleB, "HH_TABLE_END", dXmax);

    struct symtab_Parameters *pparTableStepB
	= SymbolSetParameterDouble(phsleB, "HH_TABLE_STEP", (double)iXdivs);

    //- set heccer discretization options

    struct nsintegrator_type *pelnsintegrator
	= (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

    struct simobj_Heccer *pheccerOptions = 
	pelnsintegrator->pnsintegrator->pheccerOptions;

    if( pheccerOptions->ho.iIntervalEntries != HECCER_INTERVAL_DEFAULT_ENTRIES )
    {
	fprintf(stdout,
		"Warning: Tabchannel parameter xdivs has already been set to %i for %s: (%s)\n",
		pheccerOptions->ho.iIntervalEntries, pcName,argv[4]);
    }
    else
    {
	pheccerOptions->ho.iIntervalEntries = iXdivs;
	pheccerOptions->ho.iSmallTableSize = iXdivs;
    }

    //- for voltage activated gates

    if ( !strcmp(pcField,"X") || !strcmp(pcField,"Y") ) 
    {
	if( pheccerOptions->ho.dIntervalStart != HECCER_INTERVAL_DEFAULT_START )
	{
	    fprintf(stdout,
		    "Warning: Tabchannel parameter xmin has already been set to %f for %s: (%s)\n",
		    pheccerOptions->ho.dIntervalStart, pcName,argv[5]);
	}
	else
	{
	    pheccerOptions->ho.dIntervalStart = dXmin;
	}

	if( pheccerOptions->ho.dIntervalEnd != HECCER_INTERVAL_DEFAULT_END )
	{
	    fprintf(stdout,
		    "Warning: Tabchannel parameter xmax has already been set to %f for %s: (%s)\n",
		    pheccerOptions->ho.dIntervalEnd, pcName,argv[6]);
	}
	else
	{
	    pheccerOptions->ho.dIntervalEnd = dXmax;
	}

	OK();

	return 1;
    } 

    //- for concentration activated gates

    else if (strcmp(pcField,"Z") == 0) 
    {
	if( pheccerOptions->ho.dConcentrationGateStart != 
	    HECCER_INTERVAL_CONCENTRATION_GATE_DEFAULT_START )
	{
	    fprintf(stdout,
		    "Warning: Tabchannel parameter xmin has already been set to %f for %s\n",
		    pheccerOptions->ho.dConcentrationGateStart,pcName);
	}
	else
	{
	    pheccerOptions->ho.dConcentrationGateStart = dXmin;
	}

	if( pheccerOptions->ho.dConcentrationGateEnd != 
	    HECCER_INTERVAL_CONCENTRATION_GATE_DEFAULT_END )
	{
	    fprintf(stdout,
		    "Warning: Tabchannel parameter xmax has already been set to %f for %s\n",
		    pheccerOptions->ho.dConcentrationGateEnd,pcName);
	}
	else
	{
	    pheccerOptions->ho.dConcentrationGateEnd = dXmax;
	}

	OK();

	return 1;
    } 
    else
    {
	Error();

	printf("field '%s' not known\n", pcField);

	return(0);
    }
}
