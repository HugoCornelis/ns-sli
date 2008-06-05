//------------------------------------------------------------------
/*!
 *  \file nscomm.c
 *  \author Mando Rodriguez
 *
 *  This file holds commodity functions for performing some actions 
 *  in the model container and Heccer.
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


//------------------ static function declarations ------------------
static char * mapParameter(char *pcfield);
//------------------------------------------------------------------



//----------------------------------------------------------------------------
/*!
 *  \fun int setParameter(struct symtab_HSolveListElement *phsle,
 *		 char *pcField, char *pcValue,int iFlag)
 *  
 */
//----------------------------------------------------------------------------
int setParameter(struct symtab_HSolveListElement *phsle,
		 char *pcField, char *pcValue,int iFlag){

 
       
  struct symtab_Parameters *pparTop = ParameterCalloc();
  

  if(!pparTop)
    return 0;


  char *pcParameter = NULL;
  pcParameter = mapParameter(pcField);
  

  ParameterSetName(pparTop,pcParameter);


  //-
  //- check for the GENESIS2 flag, if on then
  //- we mut allocate and set a GEN2 function parameter.
  //-
  if( iFlag == SETPARA_GENESIS2 )
  {
	  
    struct symtab_Parameters *pparScale = 
      ParameterNewFromNumber("scale",1.0);


    double dValue = atof(pcValue);
    struct symtab_Parameters *pparValue = 
      ParameterNewFromNumber("value",dValue);


    //i 
    //i The neurospaces data struct parameters are in a linked
    //i list and must be connected otherwise the parameter lookup will fail.
    //i
    pparScale->pparFirst = pparScale;
    pparScale->pparNext = pparValue;

    pparValue->pparFirst = pparScale;
    pparValue->pparNext = NULL;

    
    struct symtab_Function *pfun = FunctionCalloc();

    FunctionSetName(pfun,"GENESIS2");
    FunctionAssignParameters(pfun,pparScale);


    //-
    //- Here we assign the scaling function to the parameter pparTop 
    //-
    pparTop->uValue.pfun = pfun;

    ParameterSetType(pparTop,TYPE_PARA_FUNCTION);

  } 
  else if( iFlag == SETPARA_NUM ){


    double dNumber = strtod(pcValue,NULL);

    pparTop->uValue.dNumber = dNumber;
    ParameterSetType(pparTop,TYPE_PARA_NUMBER);

  }
  else
  {

    pparTop->uValue.pcString = pcValue;
    ParameterSetType(pparTop,TYPE_PARA_STRING);

  }


 
  pparTop->pparFirst = pparTop;


  BioComponentChangeParameter((struct symtab_BioComponent *)phsle,pparTop);
  
  return 1;


}











//----------------------------------------------------------------------------
/*!
 *   \fn static char * mapParameter(const char *pcfield)
 *   \param pcfield A pchar containing a field label from the GENESIS SLI.
 *   
 *   Maps a GENESIS field to the appropriate Neurospaces field parameter
 *   value.
 */
//----------------------------------------------------------------------------
static char * mapParameter(char *pcfield){

  char *pcresult;

  //t
  //t not sure about needing to do a string dup. 
  //t
  if(!strcmp(pcfield,"Cm")){

    //!
    //! maps to a compartment
    //!
    pcresult = "CM";

  } else if(!strcmp(pcfield,"Rm")){

    //!
    //! maps to compartment
    //!
    pcresult = "RM";

  } else if(!strcmp(pcfield,"Ra")){

    //!
    //! maps to compartment
    //!
    pcresult = "RA";

  } else if(!strcmp(pcfield,"initVm")){

    //!
    //! maps to compartment
    //!
    pcresult = "Vm_init";
  
  } else if(!strcmp(pcfield,"Eleak")){

    //!
    //! maps to compartment
    //!
    pcresult = "ELEAK";

  } else if(!strcmp(pcfield,"dia")){

    //!
    //! maps to compartment
    //!
    pcresult = "DIA";

  } else if(!strcmp(pcfield,"len")){

    //!
    //! maps to compartment
    //!
    pcresult = "LEN";

  } else if(!strcmp(pcfield,"inject")){

    //!
    //! maps to compartment
    //!
    pcresult = "INJECT";

  } else if(!strcmp(pcfield,"Em")){ 
    
    //!
    //! maps to compartment
    //!
    pcresult = "ELEAK";

  } else if(!strcmp(pcfield,"Ek")){

    //!
    //! maps to a channel
    //!
    pcresult = "Erev";

  } else if(!strcmp(pcfield,"Gbar")){

    //!
    //! maps to a channel
    //!
    pcresult = "G_MAX";

  } else if(!strcmp(pcfield,"Xpower") ||
	    !strcmp(pcfield,"Ypower") ||
	    !strcmp(pcfield,"Zpower") )
    {

    //!
    //! maps to the power parameter in channels.
    //!
    pcresult = "POWER";

  }
  else{

    //fprintf(stdout,"Unrecognized Compartment field: %s\n",pcresult);
    pcresult = pcfield;

  }


  return pcresult;
}
