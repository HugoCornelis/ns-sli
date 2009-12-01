//------------------------------------------------------------------
/*!
 *  \file nsasc.c
 *
 *  \author Hugo Cornelis
 *
 *  This file contains filters that tell the simulator core what
 *  object types are handled by the model-container.
*/
//-------------------------------------------------------------------


#include "nsintegrator.h"


static char *ppcCreate[] = {
    "Ca_concen",
    "channelC2",
    "channelC3",
    "compartment",
    "hsolve",
    "nernst",
    "neutral",
    "pulsegen",
    "spikegen",
    "symcompartment",
    "synchan",
    "tabchannel",
    NULL,
};


int NSFilterCreate(char *pcType)
{
    int iInModelContainer = 0;

    int i;

    for (i = 0 ; ppcCreate[i] ; i++)
    {
	if (strcmp(ppcCreate[i], pcType) == 0)
	{
	    iInModelContainer = 1;
	}
    }

    return(iInModelContainer);
}
