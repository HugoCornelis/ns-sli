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
  struct symtab_HSolveListElement *phsle = lookupGate(pcName,pcField);

  setParameter(phsle,"HH_Format","steadystate-tau",SETPARA_STRING);


  int i;
  double dAlpha, dBeta;
  double dTableAval, dTableBval;
  char pcTable[50];


  struct PidinStack *ppistA = getGateContext(pcName,pcField,"A");

  struct PidinStack *ppistB = getGateContext(pcName,pcField,"B");


  //!!
  //!! There is a '- 1' following a call to getting the number of table entries because 
  //!! of a glitch in the model container which causes it to return the number of entries+1.
  //!!

  struct symtab_HSolveListElement *phslegtkA = PidinStackLookupTopSymbol(ppistA); // lookupGateKinetic(pcName,pcField,"A");
  struct symtab_HSolveListElement *phslegtkB = PidinStackLookupTopSymbol(ppistB); // lookupGateKinetic(pcName,pcField,"B");


  if(!phslegtkA || !phslegtkB)
  {
      Error();
    printf("Element '%s' not found\n",pcName);
    return 0;

  }

  int iNumTabEntriesA = 
    (int)SymbolParameterResolveValue(phslegtkA, ppistA,"HH_NUMBER_OF_TABLE_ENTRIES");

  
  int iNumTabEntriesB = 
    (int)SymbolParameterResolveValue(phslegtkB, ppistB,"HH_NUMBER_OF_TABLE_ENTRIES");


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

      dAlpha  = SymbolParameterResolveValue(phslegtkA, ppistA, pcTable);

      dBeta  = SymbolParameterResolveValue(phslegtkB, ppistB, pcTable);


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

      setParameterNumber(phslegtkA, pcTable, dTableAval);
      setParameterNumber(phslegtkB, pcTable, dTableBval);
  }


  PidinStackFree(ppistA);
  PidinStackFree(ppistB);

  return 1;

}
