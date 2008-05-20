//------------------------------------------------------------------
/*!
 *  \file nssetfield.c
 *  \author Mando Rodriguez
 *
 *
*/
//------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

#include "neurospaces/function.h"
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"


//------------------ static function declaration -------------------
static char * mapParameter(const char *pcfield);
//------------------------------------------------------------------





//------------------------------------------------------------------
/*!
 *  \fn int NeurospacesSetField(struct symtab_HSolveListElement *phsle,char *field,char *value)
 *  \return 0 on error, 1 on success.
 *  \param phsle A pointer to an Hsolve list element.
 *  \param field A field value to 
 *  \param value The value to place in the field given in the previous argument.
 *
 *  Function sets a field for an Hsolve list element and maps a value to it. This
 *  is done via direct operations on the model container data struct. The steps 
 *  for this are as follows:
 *
 *  1. Allocate Parameter.
 *  2. Set Parameter Value.
 *  3. Use the FIXED function.
 *  4. Link parameter list to phsle.
 *  5. Generate a parameter from the numerical value.
*/
//------------------------------------------------------------------
int NeurospacesSetField(struct symtab_HSolveListElement *phsle, char *field, char *value){

 
  //!
  //! -The parameter fields "Ik" and "Gk" are solved variables in 
  //!  Heccer so they don't need a parameter to be set at all, thus they
  //!  are ignored completely.
  //!
  if(!phsle || 
     !strcmp(field,"") ||
     !strcmp(field,"Ik") || 
     !strcmp(field,"Gk") )
    return 0;
  

  struct symtab_Parameters *pparScale = ParameterNewFromNumber("scale",1.0);



  double dValue = atof(value);
  struct symtab_Parameters *pparValue = ParameterNewFromNumber("value",dValue);


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


  struct symtab_Parameters *pparTop = ParameterCalloc();
  

  char *pcParameter = NULL;
  if(instanceof_segment(phsle))
    pcParameter = mapParameter(field);
  else
    pcParameter = strdup(field);


  ParameterSetName(pparTop,pcParameter);
  ParameterSetType(pparTop,TYPE_PARA_FUNCTION);
		  


  pparTop->uValue.pfun = pfun;
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
static char * mapParameter(const char *pcfield){

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

  }else{

    //fprintf(stdout,"Unrecognized Compartment field: %s\n",pcresult);
    pcresult = pcfield;

  }


  return pcresult;
}
