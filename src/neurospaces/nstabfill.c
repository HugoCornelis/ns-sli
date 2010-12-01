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
 *  \fn int NSTabFill(char *pcName, char *pcField, char *pcNumTabEntries)
 *  \param argc argument count, see tabfill manual.
 *  \param argv argument vector, see tabfill manual.
 *  \return 0 on error, 1 on success.
 */
int NSTabFill(int argc, char **argv)
{
    if (argc != 6) 
    {
	Error();

	printf("usage : %s field xdivs fill_mode\n","tabfill");

	return(0);
    }

    if (strcmp("0", argv[5]))
    {
	Error();

	printf("Invalid fill_mode, must be '0'\n");

	return 0;
    }

    char *pcName = argv[1];

    char *pcField =  argv[3];

    char *pcNumTabEntries = argv[4];

  struct PidinStack * ppistA = getGateContext(pcName,pcField,"A");

  struct PidinStack * ppistB = getGateContext(pcName,pcField,"B");

  struct symtab_HSolveListElement * phsleA = PidinStackLookupTopSymbol(ppistA);

  struct symtab_HSolveListElement * phsleB = PidinStackLookupTopSymbol(ppistB);

  if(!phsleA || !phsleB)
  {
      Error();

      printf("TABFILL Error: cannot find gate kinetic elements of %s\n", pcName);

      return 0;
  }

  int iNumTabEntriesA = SymbolParameterResolveValue(phsleA, ppistA,"HH_NUMBER_OF_TABLE_ENTRIES");

  int iNumTabEntriesB = SymbolParameterResolveValue(phsleB, ppistB,"HH_NUMBER_OF_TABLE_ENTRIES");


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

  struct simobj_Heccer *pheccerOptions =  
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

    pdSourcesA[j]  = SymbolParameterResolveValue(phsleA, ppistA, pcTable);

    pdSourcesB[j]  = SymbolParameterResolveValue(phsleB, ppistB, pcTable);

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

      setParameterNumber(ppistA, phsleA, pcTable, pdDestinationsA[i]);
      setParameterNumber(ppistB, phsleB, pcTable, pdDestinationsB[i]);


  }

  //!
  //! Must update the number of table entries in the model container
  //! for each gate. If it's not updated then not all values will 
  //! be properly caculated.
  //!
  setParameterNumber(ppistA, phsleA, "HH_NUMBER_OF_TABLE_ENTRIES", (double)iDestinationSize);
  setParameterNumber(ppistB, phsleB, "HH_NUMBER_OF_TABLE_ENTRIES", (double)iDestinationSize);



  //!
  //! The destination size here becomes the new table size since the table
  //! has been interpolated to a new size.
  //!

  pheccerOptions->ho.iIntervalEntries = iDestinationSize;
 

  PidinStackFree(ppistA);
  PidinStackFree(ppistB);

  OK();

  return 1;

}
