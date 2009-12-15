//------------------------------------------------------------------
/*!
 *  \file nstweak.c
 *  \author Mando Rodriguez
 *
 *
*/
//------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"
#include <string.h>
#include "nsintegrator.h"



#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"





//-------------------------------------------------------------------
/*!
 *  \fn int NSTweakTau(char *pcName, char *pcField)
 *
 *  Performs a manipulation for tau to transform it into an AB 
 *  representation. 
 *
 *  Basis for this is the heccer function HeccerChannelSteadyStateSteppedTauTabulate
 *  in table.c
 *
 */
//-------------------------------------------------------------------
int NSTweakTau(char *pcName, char *pcField){

  
  //!
  //! Here at the start we set the HH_Format parameter on the 
  //! gate to indicate the procedure has started. 
  //!
  struct PidinStack *ppist = lookupGate(pcName,pcField);

  struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);

  setParameter(ppist, phsle,"HH_Format","steadystate-tau",SETPARA_STRING);


  int i;
  double dAlpha, dBeta;
  double dTableAval, dTableBval;
  char pcTable[50];


  struct PidinStack *ppistA = getGateContext(pcName,pcField,"A");

  struct PidinStack *ppistB = getGateContext(pcName,pcField,"B");


  //- Here we set the state_init parameter. 

  struct PidinStack *ppistGate = PidinStackDuplicate(ppistA);
  PidinStackPop(ppistGate);
  setStateInit(ppistGate);

  struct symtab_HSolveListElement *phsleA = PidinStackLookupTopSymbol(ppistA);
  struct symtab_HSolveListElement *phsleB = PidinStackLookupTopSymbol(ppistB);


  if(!phsleA || !phsleB)
  {
      Error();
    printf("Element '%s' not found\n",pcName);
    return 0;

  }

  int iNumTabEntriesA = 
    (int)SymbolParameterResolveValue(phsleA, ppistA,"HH_NUMBER_OF_TABLE_ENTRIES");

  
  int iNumTabEntriesB = 
    (int)SymbolParameterResolveValue(phsleB, ppistB,"HH_NUMBER_OF_TABLE_ENTRIES");


  if( iNumTabEntriesA != iNumTabEntriesB )
  {
      Error();

    printf(
	   "Error: Gate kinetic A and B for gate \'%s\' have a different number of table entries.\n",
	   pcName);
    return 0;

  }

  int iNumTabEntries = iNumTabEntriesA;


  for(i=0;i<iNumTabEntries;i++)
  {
      sprintf(&pcTable[0], "table[%i]", i);

      dAlpha  = SymbolParameterResolveValue(phsleA, ppistA, pcTable);

      dBeta  = SymbolParameterResolveValue(phsleB, ppistB, pcTable);


      if (fabs(dAlpha) < 1e-17)
      {
	if (dAlpha < 0.0)
	{
	  dAlpha = -1e-17;
	}
	else
	{
	  dAlpha = 1e-17;
	}
      }      

      dTableAval = dBeta / dAlpha;
      dTableBval = 1.0 / dAlpha;

      setParameterNumber(ppistA, phsleA, pcTable, dTableAval);
      setParameterNumber(ppistB, phsleB, pcTable, dTableBval);
  }


  PidinStackFree(ppistA);
  PidinStackFree(ppistB);

  return 1;

}
