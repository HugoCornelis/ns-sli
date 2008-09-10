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
#include "sim_ext.h"
#include <string.h>
#include "nsintegrator.h"



#include "neurospaces/function.h"
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"





//-------------------------------------------------------------------
/*!
 *  \func int NSTweakTau(char *pcName, char *pcField)
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

  
  struct symtab_HSolveListElement *phsle, *phslegtkA, *phslegtkB;

  phsle = lookupGate(pcName,pcField);

  phslegtkA = lookupGateKinetic(pcName,pcField,"A");
  phslegtkB = lookupGateKinetic(pcName,pcField,"B");


  if(!phslegtkA || !phslegtkB)
  {

    printf("Element '%s' not found\n",pcName);
    return 0;

  }

  //!
  //! Here at the start we set the HH_Format parameter on the 
  //! gate to indicate the procedure has started. 
  //!
  setParameter(phsle,"HH_Format","steadystate-tau",SETPARA_STRING);


  //!
  //! Fetch the global heccer options data member to get the number
  //! of enries.
  struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  struct Heccer *pheccerOptions = 
      pelnsintegrator->pnsintegrator->pheccerOptions;
  

  int iNumTabEntries = pheccerOptions->ho.iIntervalEntries;


  int i;
  double dAlpha, dBeta;
  double dTableAval, dTableBval;
  char pcTable[50];


  struct PidinStack *ppistA = getGateContext(pcName,pcField,"A");

  struct PidinStack *ppistB = getGateContext(pcName,pcField,"B");


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


  return 1;

}
