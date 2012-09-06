//------------------------------------------------------------------
/*!
 *  \file nsgetfield.c
 *  \author Mando Rodriguez
 *
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "sim_ext.h"
#include "shell_func_ext.h"

#include <heccer/addressing.h>
#include "nsintegrator.h"
#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"


/*
 * Return -1 on continue, NULL on error, pointer on success.
 */
char* NSGetField(char *pcPathname,char *pcField)
{
    //- do hsolve correction for fields

    if (undo_findsolvefield(&pcPathname, &pcField))
    {
    }
    else
    {
	pcPathname = strdup(pcPathname);

	pcField = strdup(pcField);
    }

    // First we check for the variable in heccer

    char *pcHeccerVar = GetHeccerVariable(pcPathname, pcField);

    if (pcHeccerVar)
    {
	free(pcPathname);
	free(pcField);
    
	return(pcHeccerVar);
    }

    // if it's not in heccer then we proceed to check the model
    // container.

    struct PidinStack *ppist = PidinStackParse(pcPathname);

    struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

    if (!phsle)
    {
	//- in this case it's not in the model container.

	free(pcPathname);
	free(pcField);

	return (char*) -1;
    }

    char *pcMappedPar = mapParameterString(pcField);

    if (strcmp(pcMappedPar, "nsynapses") == 0)
    {
	// \todo this should come from ppist

	extern struct Neurospaces *pneuroGlobal;

	struct ProjectionQuery *ppq = NeurospacesGetProjectionQuery(pneuroGlobal);

	if (!ppq)
	{
	    QueryMachineHandle(pneuroGlobal, "pqsetall c");
	}
    }

    //- lookup parameter

    char pcValue[1000] = "";

    struct symtab_Parameters *ppar
	= SymbolFindParameter(phsle, ppist, pcMappedPar);

    if (ppar)
    {
	//- for numeric indirect parameter values

	if (ParameterIsNumber(ppar)
	    || ParameterIsFunction(ppar)
	    || ParameterIsField(ppar))
	{
	    //- resolve parameter value

	    double dValue = ParameterResolveValue(ppar, ppist);

	    if (dValue == DBL_MAX)
	    {
		Error();

		printf("could not get the value for field '%s->%s', unresolvable value\n", pcPathname, pcField);

		free(pcPathname);
		free(pcField);

		return(NULL);  
	    }

	    sprintf(pcValue, "%g", dValue);
	}

	//- for string parameter values

	else if (ParameterIsString(ppar))
	{
	    strcpy(pcValue, ParameterGetString(ppar));
	}

	//- otherwise

	else if (ParameterIsSymbolic(ppar))
	{
	    Error();

	    printf("could not get the value for field '%s->%s', its value is a symbolic reference\n", pcPathname, pcField);

	    free(pcPathname);
	    free(pcField);

	    return(NULL);  
	}
	else if (ParameterIsAttribute(ppar))
	{
	    Error();

	    printf("could not get the value for field '%s->%s', its value is an attribute\n", pcPathname, pcField);

	    free(pcPathname);
	    free(pcField);

	    return(NULL);  
	}

    }

    free(pcPathname);
    free(pcField);

    return(CopyString(pcValue));
}





//--------------------------------------------------------
/*
 *
 */
//---------------------------------------------------------
char * GetHeccerVariable(char *pcName,char *pcField)
{


  struct neurospaces_integrator *pnsintegrator = getNsintegrator();
  
  int i = LookupHeccerIndex(pcName);

  if (i == -1)
  {
      fprintf(stdout, "Warning: No heccer found for %s->%s.\n\n", pcName, pcField);

      return NULL;
  }

  if(!pnsintegrator->psr[i].uSolver.si.pheccer)
  {

    if(!strcmp(pcField,"Vm"))
    {
      fprintf(stdout,"%s","Warning: No simulation has been run, Vm is not avaialble.\n\n");
    }

    return NULL;

  }

  struct PidinStack *ppist = PidinStackParse(pcName);

  PidinStackUpdateCaches(ppist);

  int iSerial = PidinStackToSerial(ppist);

  double *pdValue = HeccerAddressVariable(pnsintegrator->psr[i].uSolver.si.pheccer, iSerial, pcField);

  if(!pdValue)
    return NULL;


  char pc[100];

  sprintf(pc,"%g",(*pdValue));

  return (CopyString(pc));

}
