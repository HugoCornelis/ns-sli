//------------------------------------------------------------------
/*!
 *  \file nstabfill.c
 *  \author Mando Rodriguez
 *
 * 
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

#include "neurospaces/function.h"
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"

#include "nsintegrator.h"




int NSTabFill(char *pcName, char *pcField, char *pcNumTabEntries)
{

  

  struct symtab_HSolveListElement * phslegtkA = 
    lookupGateKinetic(pcName,pcField,"A");

  struct symtab_HSolveListElement * phslegtkB = 
    lookupGateKinetic(pcName,pcField,"B");


  if(!phslegtkA || !phslegtkB)
  {

    printf("TABFILL Error: Field %s is not known for %s\n",pcField,pcName);
    return 0;

  }



  struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  struct Heccer *pheccerOptions = 
      pelnsintegrator->pnsintegrator->pheccerOptions;


  int iCurrentNumEntries = pheccerOptions->ho.iIntervalEntries;

 
  double *ppdSourcesA = (double*)calloc(iCurrentNumEntries,sizeof(double));

  int i;
  
  char pcTable[50];

  struct PidinStack * ppistA = getGateContext(pcName,pcField,"A");

  struct PidinStack * ppistB = getGateContext(pcName,pcField,"B");

  double *ppdSources[] =
    {
      NULL,
      NULL,
      NULL,
    };

  double *ppdDestinations[] =
    {
      NULL,
      NULL,
      NULL,
    };



  
  int iDestinationSize = atoi(pcNumTabEntries);

    
  ppdSources[0] = (double *)calloc(iCurrentNumEntries, sizeof(double));
  ppdSources[1] = (double *)calloc(iCurrentNumEntries, sizeof(double));

  double *pdSourcesA = ppdSources[0];
  double *pdSourcesB = ppdSources[1];

  int j;


  for(j=0;j<iCurrentNumEntries;j++)
    {
      sprintf(&pcTable[0], "table[%i]", j);

      pdSourcesA[j]  = SymbolParameterResolveValue(phslegtkA, ppistA, pcTable);

      pdSourcesB[j]  = SymbolParameterResolveValue(phslegtkB, ppistB, pcTable);

    }



      //double *pdDestinations = ppdDestinations[0];

  ppdDestinations[0] = (double *)calloc(iDestinationSize+1, sizeof(double));  
  ppdDestinations[1] = (double *)calloc(iDestinationSize+1, sizeof(double));

  double *pdDestinationsA = ppdDestinations[0];
  double *pdDestinationsB = ppdDestinations[1];

  HeccerTableInterpolate(ppdSources,ppdDestinations,iCurrentNumEntries,iDestinationSize);
    

 


  for(i=0; i < iDestinationSize; i++)
  {


      sprintf(&pcTable[0], "table[%i]", i);

      setParameterNumber(phslegtkA, pcTable, pdDestinationsA[i]);
      setParameterNumber(phslegtkB, pcTable, pdDestinationsB[i]);


  }



  //!
  //! The destination size here becomes the new table size.
  //!
  pheccerOptions->ho.iIntervalEntries = iDestinationSize;
 

    //  free(ppdSourcesA);
    //free(ppdDestinationsA);

  return 1;

}
