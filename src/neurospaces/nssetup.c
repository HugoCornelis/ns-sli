//------------------------------------------------------------------
/*!
 *  \file nssetup.c
 *  \author Mando Rodriguez
 *
 *
*/
//------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

#include "nsintegrator.h"

#include "neurospaces/function.h"
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"


//------------------------------------------------------------------
/*
 *
 */
//------------------------------------------------------------------
int NSSetupAlpha( char *pcName, char *pcField, char **pcArgs, 
		  int iArgc){

  struct symtab_HSolveListElement *phsle;
  int i;

  if(!strcmp(pcField,"X"))
  {


    //- get a contect for the element we're looking for
    struct PidinStack *ppist  = PidinStackParse(pcName);




    //- First we fetch the forward gate
    struct PidinStack *ppistForward = PidinStackDuplicate(ppist);

    PidinStackPushString(ppistForward,"HH_activation");

    struct symtab_HSolveListElement *phsleForward = 
	  PidinStackPushStringAndLookup(ppistForward,"forward");
    
    PidinStackFree(ppistForward);

    if(!phsleForward){
      fprintf(stdout,"Could not find forward gate kinetic for %s\n",pcName);
      return 0;
    }


    //- Set the forward parameters.
    //-    HH_AB_Scale - is at index 0
    //-    HH_AB_Mult - is at index 1
    //-    HH_AB_Factor_Flag - is not present in the double array, 
    //-                        it's allocated seperately.
    //-    HH_AB_Add  -  is at index 2
    //-    HH_AB_Offset_E - is at index 3
    //-    HH_AB_Tau - is at index 4
    //-
    setParameter(phsleForward,"HH_AB_Scale",pcArgs[0],SETPARA_NUM);
    setParameter(phsleForward,"HH_AB_Mult",pcArgs[1],SETPARA_NUM);
    setParameter(phsleForward,"HH_AB_Factor_Flag","-1.0",SETPARA_NUM);
    setParameter(phsleForward,"HH_AB_Add",pcArgs[2],SETPARA_NUM);
    setParameter(phsleForward,"HH_AB_Offset_E",pcArgs[3],SETPARA_NUM);
    setParameter(phsleForward,"HH_AB_Tau",pcArgs[4],SETPARA_NUM);



    //- Now fetch the backward gate.
    struct PidinStack *ppistBackward = PidinStackDuplicate(ppist);

    PidinStackPushString(ppistBackward,"HH_activation");

    struct symtab_HSolveListElement *phsleBackward =
      PidinStackPushStringAndLookup(ppistBackward,"backward");


    PidinStackFree(ppistBackward);


    if(!phsleBackward){
      fprintf(stdout,"Could not find backward gate for %s\n",pcName);
      return 0;
    }  

    //- Set the backward parameters like they were set before. 
    //-    HH_AB_Scale - is at index 5
    //-    HH_AB_Mult - is at index 6
    //-    HH_AB_Factor_Flag - is not present in the double array, 
    //-                        it's allocated seperately.
    //-    HH_AB_Add  -  is at index 7
    //-    HH_AB_Offset_E - is at index 8
    //-    HH_AB_Tau - is at index 9
    //-
    setParameter(phsleBackward,"HH_AB_Scale",pcArgs[5],SETPARA_NUM);
    setParameter(phsleBackward,"HH_AB_Mult",pcArgs[6],SETPARA_NUM);
    setParameter(phsleBackward,"HH_AB_Factor_Flag","-1.0",SETPARA_NUM);
    setParameter(phsleBackward,"HH_AB_Add",pcArgs[7],SETPARA_NUM);
    setParameter(phsleBackward,"HH_AB_Offset_E",pcArgs[8],SETPARA_NUM);
    setParameter(phsleBackward,"HH_AB_Tau",pcArgs[9],SETPARA_NUM);


    //-
    //- This is for setting heccer options and passing them to 
    //- the channel setup.
    //-
  
    struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

    struct Heccer *pheccerOptions = 
      pelnsintegrator->pnsintegrator->pheccerOptions;

    
    pheccerOptions->ho.iIntervalEntries = atoi(pcArgs[10]);
    pheccerOptions->ho.dIntervalStart = strtod(pcArgs[11],NULL);
    pheccerOptions->ho.dIntervalEnd = strtod(pcArgs[12],NULL);

    return 1;


  }
  else if(!strcmp(pcField,"Y"))
  {





  }

  //  return setParameter(phsle,field,value,SETPARA_GENESIS2);
  return 1;
}
