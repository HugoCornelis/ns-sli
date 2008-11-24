//------------------------------------------------------------------
/*!
 *  \file nssetup.c
 *  \author Mando Rodriguez
 *
 *  Contains the implementation for setting a series of specific 
 *  fields, given via script, for use in a simulation.
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


//------------------------------------------------------------------
/*!
 *  \fun int NSSetupAlpha( char *pcName, char *pcField, char **pcArgs, int iArgc)
 *  \param pcName The element name to set up values for.
 *  \param pcField The field (X, Y, or Z) which determines where to place the values.
 *  \param pcArgs An array of strings which contain the values to be parsed.
 *  \param iArgc An integer which indicates the number of strings in pcArgs
 *  \return 0 on error, 1 on success.
 *
 *  Performs the GENESIS command 'setupalpha' and delegates values 
 *  from the GENESIS SLI to the neurospaces model-container.
 *
 */
//------------------------------------------------------------------
int NSSetupAlpha( char *pcName, char *pcField, char **pcArgs, 
		  int iArgc){

  struct symtab_HSolveListElement *phsle;
  int i;
  //int iAllZeros;


  /*
   * First I check for all zeros. 
   * If all the arguments are zero then there's no need
   * to create the gate.
   */
  //   iAllZeros = 0; 

  // for(i = 0; i < 10; i++) 
  // { 

  //  if(atoi(pcArgs) != 0) 
  //  { 
  //     iAllZeros = 1; 
  //     break; 
  //   } 

  // } 

  
   //- If all arguments are zero then no need to create a gate  
   //-  
  // if(iAllZeros) 
  //   return 1; 



  if(!strcmp(pcField,"X") )
  {


    //- get a contect for the element we're looking for
    struct PidinStack *ppist  = PidinStackParse(pcName);



    //- First we fetch the forward gate
    struct PidinStack *ppistForward = PidinStackDuplicate(ppist);

    PidinStackPushString(ppistForward,"HH_activation");


    //- Here we set the state_init parameter. 
    setStateInit(ppistForward);
  

    struct symtab_HSolveListElement *phsleForward = 
	  PidinStackPushStringAndLookup(ppistForward,"A");
    
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
      PidinStackPushStringAndLookup(ppistBackward,"B");


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

    

    if( pheccerOptions->ho.iIntervalEntries == HECCER_INTERVAL_DEFAULT_ENTRIES )
     pheccerOptions->ho.iIntervalEntries = atoi(pcArgs[10]);
    

    if( pheccerOptions->ho.dIntervalStart == HECCER_INTERVAL_DEFAULT_START)
      pheccerOptions->ho.dIntervalStart = strtod(pcArgs[11],NULL);
    
    if( pheccerOptions->ho.dIntervalEnd == HECCER_INTERVAL_DEFAULT_END )
      pheccerOptions->ho.dIntervalEnd = strtod(pcArgs[12],NULL);

    return 1;


  }
  else if(!strcmp(pcField,"Y"))
  {



    //- get a contect for the element we're looking for
    struct PidinStack *ppist  = PidinStackParse(pcName);

 
    //- First we fetch the forward gate
    struct PidinStack *ppistForward = PidinStackDuplicate(ppist);

    PidinStackPushString(ppistForward,"HH_inactivation");


    //- Here we set the state_init parameter. 
    setStateInit(ppistForward);
  

    struct symtab_HSolveListElement *phsleForward = 
	  PidinStackPushStringAndLookup(ppistForward,"A");
    
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

    PidinStackPushString(ppistBackward,"HH_inactivation");

    struct symtab_HSolveListElement *phsleBackward =
      PidinStackPushStringAndLookup(ppistBackward,"B");


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

    

    if( pheccerOptions->ho.iIntervalEntries == HECCER_INTERVAL_DEFAULT_ENTRIES )
     pheccerOptions->ho.iIntervalEntries = atoi(pcArgs[10]);
    

    if( pheccerOptions->ho.dIntervalStart == HECCER_INTERVAL_DEFAULT_START)
      pheccerOptions->ho.dIntervalStart = strtod(pcArgs[11],NULL);
    
    if( pheccerOptions->ho.dIntervalEnd == HECCER_INTERVAL_DEFAULT_END )
      pheccerOptions->ho.dIntervalEnd = strtod(pcArgs[12],NULL);


    return 1;



  }
  else if(!strcmp(pcField,"Z"))
  {



    //- get a contect for the element we're looking for
    struct PidinStack *ppist  = PidinStackParse(pcName);

 
    //- First we fetch the forward gate
    struct PidinStack *ppistForward = PidinStackDuplicate(ppist);

    PidinStackPushString(ppistForward,"HH_concentration");


    //- Here we set the state_init parameter. 
    setStateInit(ppistForward);
  


 

    struct symtab_HSolveListElement *phsleForward = 
	  PidinStackPushStringAndLookup(ppistForward,"A");
    
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
    // setParameter(phsleForward,"HH_AB_Scale",pcArgs[0],SETPARA_NUM);
    // setParameter(phsleForward,"HH_AB_Mult",pcArgs[1],SETPARA_NUM);
    // setParameter(phsleForward,"HH_AB_Factor_Flag","-1.0",SETPARA_NUM);
    // setParameter(phsleForward,"HH_AB_Add",pcArgs[2],SETPARA_NUM);
    // setParameter(phsleForward,"HH_AB_Offset_E",pcArgs[3],SETPARA_NUM);
    // setParameter(phsleForward,"HH_AB_Tau",pcArgs[4],SETPARA_NUM);



    //- Now fetch the backward gate.
    struct PidinStack *ppistBackward = PidinStackDuplicate(ppist);

    PidinStackPushString(ppistBackward,"HH_concentration");

    struct symtab_HSolveListElement *phsleBackward =
      PidinStackPushStringAndLookup(ppistBackward,"B");


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
    // setParameter(phsleBackward,"HH_AB_Scale",pcArgs[5],SETPARA_NUM);
    // setParameter(phsleBackward,"HH_AB_Mult",pcArgs[6],SETPARA_NUM);
    // setParameter(phsleBackward,"HH_AB_Factor_Flag","-1.0",SETPARA_NUM);
    // setParameter(phsleBackward,"HH_AB_Add",pcArgs[7],SETPARA_NUM);
    // setParameter(phsleBackward,"HH_AB_Offset_E",pcArgs[8],SETPARA_NUM);
    // setParameter(phsleBackward,"HH_AB_Tau",pcArgs[9],SETPARA_NUM);



    //-
    //- This is for setting heccer options and passing them to 
    //- the channel setup.
    //-
  
    struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

    struct Heccer *pheccerOptions = 
      pelnsintegrator->pnsintegrator->pheccerOptions;

    
    //! no need to worry about this variable at the moment
    //if( pheccerOptions->ho.iSmallTableSize == HECCER_INTERVAL_DEFAULT_END )
    //  pheccerOptions->ho.iSmallTableSize = atoi(pcArgs[10]);
    

    if( pheccerOptions->ho.dConcentrationGateStart == 
	HECCER_INTERVAL_CONCENTRATION_GATE_DEFAULT_START )
      pheccerOptions->ho.dConcentrationGateStart = strtod(pcArgs[11],NULL);


    if( pheccerOptions->ho.dConcentrationGateEnd  == 
	HECCER_INTERVAL_CONCENTRATION_GATE_DEFAULT_END )
      pheccerOptions->ho.dConcentrationGateEnd = strtod(pcArgs[12],NULL);


    return 1;



  }
  else{


    printf("%s:%s\n","Invalid field in setupalpha",pcField);

    return 0;

  }

  //  return setParameter(phsle,field,value,SETPARA_GENESIS2);
  return 1;
}








//------------------------------------------------------------------
/*
 *
 */
//------------------------------------------------------------------
int NSSetupTau( char *pcName, char *pcField, char **pcArgs, 
		  int iArgc){

  struct symtab_HSolveListElement *phsle;
  int i;

  
  return 1;

}












