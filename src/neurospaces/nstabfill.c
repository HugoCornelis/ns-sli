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

#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"

#include "nsintegrator.h"



/*!
 *  \fun int NSTabFill(char *pcName, char *pcField, char *pcNumTabEntries)
 *  \param pcName String to a tabchannel name to create.
 *  \param pcField The field (X,Y,or Z) to modify for the table.
 *  \param pcNumTabEntries The number of table entries to create.
 *  \return 0 on error, 1 on success.
 */
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


  struct PidinStack * ppistA = getGateContext(pcName,pcField,"A");

  struct PidinStack * ppistB = getGateContext(pcName,pcField,"B");

  //!!
  //!! There is a '- 1' following a call to getting the number of table entries because 
  //!! of a glitch in the model container which causes it to return the number of entries+1.
  //!!
  int iNumTabEntriesA = 
    (int)SymbolParameterResolveValue(phslegtkA, ppistA,"HH_NUMBER_OF_TABLE_ENTRIES");

  
  int iNumTabEntriesB = 
    (int)SymbolParameterResolveValue(phslegtkB, ppistB,"HH_NUMBER_OF_TABLE_ENTRIES");


  if( iNumTabEntriesA != iNumTabEntriesB )
  {

    printf(
	   "Error: Gate kinetic A and B for gate \'%s\' have a different number of table entries.\n",
	   pcName);
    return 0;

  }


  int iCurrentNumEntries = iNumTabEntriesA;

 
  double *ppdSourcesA = (double*)calloc(iCurrentNumEntries,sizeof(double));

  int i;
  
  char pcTable[50];


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


  struct nsintegrator_type *pelnsintegrator 
       = (struct nsintegrator_type *)GetElement("/neurospaces_integrator"); 

  struct Heccer *pheccerOptions =  
       pelnsintegrator->pnsintegrator->pheccerOptions; 

  int iSourceSize = pheccerOptions->ho.iSmallTableSize;
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

  HeccerTableInterpolate(ppdSources,ppdDestinations,iSourceSize,iDestinationSize);
    

 


  for(i=0; i < iDestinationSize; i++)
  {


      sprintf(&pcTable[0], "table[%i]", i);

      setParameterNumber(phslegtkA, pcTable, pdDestinationsA[i]);
      setParameterNumber(phslegtkB, pcTable, pdDestinationsB[i]);


  }

  //!
  //! Must update the number of table entries in the model container
  //! for each gate. If it's not updated then not all values will 
  //! be properly caculated.
  //!
  setParameterNumber(phslegtkA, "HH_NUMBER_OF_TABLE_ENTRIES", (double)iDestinationSize);
  setParameterNumber(phslegtkB, "HH_NUMBER_OF_TABLE_ENTRIES", (double)iDestinationSize);



  //!
  //! The destination size here becomes the new table size since the table
  //! has been interpolated to a new size.
  //!

  pheccerOptions->ho.iIntervalEntries = iDestinationSize;
 

  return 1;

}
