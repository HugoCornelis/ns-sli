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


//------------------ static function declarations ------------------
static char * mapParameter(const char *pcfield);
static int setParameter(struct symtab_HSolveListElement *phsle,
			char *pcField, char *pcValue);
//------------------------------------------------------------------





//------------------------------------------------------------------
/*!
 *  \fn int NeurospacesSetField(struct symtab_HSolveListElement *phsle,char *field,char *value)
 *  \return 0 on error, 1 on success.
 *  \param phsle A pointer to an Hsolve list element.
 *  \param ppist A Pidin stack for searching for child objects.
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
int NeurospacesSetField(struct symtab_HSolveListElement *phsle, 
			struct PidinStack *ppist,char *field, char *value){

 
 
  //!
  //! -The parameter fields "Ik" and "Gk" are solved variables in 
  //!  Heccer so they don't need a parameter to be set at all, thus they
  //!  are ignored completely.
  //!
  if(!phsle || 
     !strcmp(field,"Ik") || 
     !strcmp(field,"Gk") )
    return 0;
  




  //-
  //- Check the type on the phsle object passed. For certain types
  //- we must add parameters to the child objects rather than the object
  //- itself.
  //-
  if (phsle->iType ==  8){



    //-
    //- Parameter Xpower is set in the HH gate object, which
    //- is set as a child to the phsle object in the model container.
    //- 
    //-    Channel -> 
    //-               HH_gate -parameter-> Xpower
    //-
    //- is the order we must traverse the stack to get to the object.. 
    //-
    if (strcmp(field, "Xpower") == 0){

      
      //char *pcHHgate = strcat(,"/HH_activation");

      struct symtab_HSolveListElement *phsleGate = 
	PidinStackGetPhsle(ppist,"/hardcoded_neutral/c/nap/HH_activation");

      if(!phsleGate)
	return 0;

      return setParameter(phsle,field,value);


    }     
    else if (strcmp(field, "Ypower") == 0){


      struct symtab_HSolveListElement *phsleGate
	    =   PidinStackGetPhsle(ppist,"/hardcoded_neutral/c/nap/HH_activation");

      if(!phsleGate)
	return 0;

      return setParameter(phsle,field,value);


    }


  }


  return setParameter(phsle,field,value);

}






//----------------------------------------------------------------------------
/*!
 *
 *
 */
//----------------------------------------------------------------------------
static int setParameter(struct symtab_HSolveListElement *phsle,
			char *pcField, char *pcValue){

  struct symtab_Parameters *pparScale = ParameterNewFromNumber("scale",1.0);



  double dValue = atof(pcValue);
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
  pcParameter = mapParameter(pcField);
  


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
