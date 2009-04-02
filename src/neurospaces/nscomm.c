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


#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"

#include "nsintegrator.h"


//------------------ static function declarations ------------------
static char * mapParameter(char *pcfield);
//------------------------------------------------------------------





//---------------------------------------------------------------------------
/*
 *
 */
//---------------------------------------------------------------------------
struct GateState{

  char *pcName;
  char *pcValue;

};



struct GateState GateStateTableInitializers[] =
{
  //{"nap/HH_activation", "0.7612305421"},
  //  {"naf/HH_inactivation", "0.26397776926502026"},
  //{"naf/HH_activation","0.007840644937141521"},

  //  {"cap/HH_inactivation", "0.9868968318"},
  //  {"cap/HH_activation","0.001391094927"},

  //{"cat/HH_inactivation", "0.082602128127539254"},
  //{"cat/HH_activation", "0.038918706451336625"},
  //  {"ka/HH_inactivation", "0.7474853827"},
  //{"ka/HH_activation", "0.08371356085"},
  //{"kc/HH_activation","0.063531859768213905"},
  //{"kc/HH_concentration","0.0099009900989999993"},
  // {"h1/HH_activation","0.03540844397"},
  {NULL, NULL},
};



int setStateInit(struct PidinStack *ppist){

  
  char pc[200];
  bzero((void*)pc,200);

  PidinStackString(ppist, pc, sizeof(pc));
      
  int i;
  int iNameLen;
  int iContextLen  = strlen(pc);
  char *pcTail;
  struct symtab_HSolveListElement *phsle;

  for (i = 0 ; GateStateTableInitializers[i].pcName != NULL; i++)
  {
    
    
    iNameLen = strlen(GateStateTableInitializers[i].pcName);

    if(iNameLen >= iContextLen)
      return 0;

    pcTail = &pc[iContextLen - iNameLen];


    if(!strcmp(GateStateTableInitializers[i].pcName,pcTail)){

      phsle = PidinStackLookupTopSymbol(ppist);

      if(!phsle)
	return 0;

      setParameter(phsle, "state_init",
		   GateStateTableInitializers[i].pcValue,
		   SETPARA_GENESIS2);

      return 1;

    }
 

    
  }


  return 1;

}
//- end setStateInit -------------------------------------------------------------------






//----------------------------------------------------------------------------
/*!
 *  \fn int setParameter(struct symtab_HSolveListElement *phsle,
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
  else if( iFlag == SETPARA_NUM )
  {


    double dNumber = strtod(pcValue,NULL);

    pparTop->uValue.dNumber = dNumber;
    ParameterSetType(pparTop,TYPE_PARA_NUMBER);

  }
  else if( iFlag == SETPARA_FIELD )
  {

    struct PidinStack *ppist  = PidinStackParse(pcValue);

    struct symtab_IdentifierIndex *pidin = 
      PidinStackToPidinQueue(ppist);

    pparTop->uValue.pidin = pidin;
    ParameterSetType(pparTop,TYPE_PARA_FIELD);

  }
  else
  {

    pparTop->uValue.pcString = pcValue;
    ParameterSetType(pparTop,TYPE_PARA_STRING);

  }


 

  BioComponentChangeParameter((struct symtab_BioComponent *)phsle,pparTop);
  
  return 1;


}


//-------------------------------------------------------------
/*!
 *  \fn int setParameterNumber(struct symtab_HSolveListElement *phsle, 
                               char *pcField, double dNumber)
 *
 *   Function to to set a number without the overhead of 
 *   reconverting it back into a string for setParameter().
 *   
 */
//-------------------------------------------------------------
int setParameterNumber(struct symtab_HSolveListElement *phsle,
		 char *pcField, double dNumber)
{


      
  struct symtab_Parameters *pparTop = ParameterCalloc();
  

  if(!pparTop)
    return 0;


  char *pcParameter = NULL;
  pcParameter = mapParameter(pcField);
  

  ParameterSetName(pparTop,pcParameter);
		       

  pparTop->uValue.dNumber = dNumber;
  ParameterSetType(pparTop,TYPE_PARA_NUMBER);


  pparTop->pparFirst = pparTop;


  BioComponentChangeParameter((struct symtab_BioComponent *)phsle,pparTop);
  
  return 1;


}








//----------------------------------------------------------------------------
/*!
 *   \fn static char * mapParameter(char *pcfield)
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

  } else if(!strcmp(pcfield,"Gbar") || 
	    !strcmp(pcfield,"gmax")){

    //!
    //! maps to a channel
    //!
    pcresult = "G_MAX";

  } else if(!strcmp(pcfield,"Xpower") ||
	    !strcmp(pcfield,"Ypower") ||
	    !strcmp(pcfield,"Zpower") )
    {

    //!
    //! maps to the power parameter in gates.
    //!
    pcresult = "POWER";

    } 
  else if(!strcmp(pcfield,"tau"))
  {
    
    pcresult = "TAU";

  }
  else if(!strcmp(pcfield,"tau1"))
  {
    
    pcresult = "TAU1";

  }
  else if(!strcmp(pcfield,"tau2"))
  {
    
    pcresult = "TAU2";

  }
  else if(!strcmp(pcfield,"thick"))
  {

    pcresult = "THICK";

  }
  else if(!strcmp(pcfield,"Ca_base"))
  {

    pcresult = "BASE";

  }
  else if(!strcmp(pcfield,"B"))
  {

    pcresult = "BETA";

  }
  else{

    //fprintf(stdout,"Unrecognized Compartment field: %s\n",pcresult);
    pcresult = strdup(pcfield);

  }


  return pcresult;
}



//-----------------------------------------------------------------
/*!
 *
 */
//-----------------------------------------------------------------
struct symtab_HSolveListElement * lookupGateKinetic(char *pcName, char *pcField, char *pcAorB)
{

  struct symtab_HSolveListElement *phsle = NULL;


  struct PidinStack *ppist  = PidinStackParse(pcName);



  struct PidinStack *ppistCopy = PidinStackDuplicate(ppist);

  
  
  if(!strcmp(pcField,"X") || !strcmp(pcField,"Xpower"))
  {

    PidinStackPushString(ppistCopy,"HH_activation");


  }
  else if(!strcmp(pcField,"Y") || !strcmp(pcField,"Ypower"))
  {

    PidinStackPushString(ppistCopy,"HH_inactivation");
    

  }
  else if(!strcmp(pcField,"Z") || !strcmp(pcField,"Zpower"))
  {

    PidinStackPushString(ppistCopy,"HH_concentration");
    

  }
  else
  {

    PidinStackFree(ppist);
    PidinStackFree(ppistCopy);
    return NULL;

  }


  if(!strcmp(pcAorB,"A") || !strcmp(pcAorB,"B"))
  {

    phsle = PidinStackPushStringAndLookup(ppistCopy,pcAorB);

  }
  else
  {

    phsle = PidinStackLookupTopSymbol(ppistCopy);

  }



  PidinStackFree(ppistCopy);
  
  return phsle;


}



//------------------------------------------------------------------
/*!
 *
 */
//------------------------------------------------------------------
struct symtab_HSolveListElement * lookupGate(char *pcName, char *pcField)
{


  struct symtab_HSolveListElement *phsle = NULL;


  struct PidinStack *ppist  = PidinStackParse(pcName);



  struct PidinStack *ppistCopy = PidinStackDuplicate(ppist);

  
  
  if(!strcmp(pcField,"X") || !strcmp(pcField,"Xpower"))
  {

    phsle = PidinStackPushStringAndLookup(ppistCopy,"HH_activation");


  }
  else if(!strcmp(pcField,"Y") || !strcmp(pcField,"Ypower"))
  {

    phsle = PidinStackPushStringAndLookup(ppistCopy,"HH_inactivation");
    

  }
  else if(!strcmp(pcField,"Z") || !strcmp(pcField,"Zpower"))
  {

    phsle = PidinStackPushStringAndLookup(ppistCopy,"HH_concentration");
    

  }


  PidinStackFree(ppistCopy);
  
  return phsle;


}




//-----------------------------------------------------------------
/*!
 *
 */
//-----------------------------------------------------------------
 struct PidinStack * getGateContext(char *pcName, char *pcField, char *pcAorB)
{



  struct PidinStack *ppist  = PidinStackParse(pcName);


  if(!ppist)
    return NULL;
  
  
  if(!strcmp(pcField,"X") || !strcmp(pcField,"Xpower"))
  {

    PidinStackPushString(ppist,"HH_activation");


  }
  else if(!strcmp(pcField,"Y") || !strcmp(pcField,"Ypower"))
  {

    PidinStackPushString(ppist,"HH_inactivation");
    

  }
  else if(!strcmp(pcField,"Z") || !strcmp(pcField,"Zpower"))
  {

    PidinStackPushString(ppist,"HH_concentration");
    

  }


  if(!strcmp(pcAorB,"A") || !strcmp(pcAorB,"B"))
  {

    PidinStackPushString(ppist,pcAorB);

  }


  return ppist;


}



/*
 *
 */
struct neurospaces_integrator *getNsintegrator(){

  struct nsintegrator_type *pelnsintegrator
    = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  return pelnsintegrator->pnsintegrator;

}



//--------------------------------------------------------------------
/*!
 *
 */
//--------------------------------------------------------------------
struct symtab_InputOutput * CreateInputOutput(char *pcContext, int iType)
{



  //  char *pc = strdup(pcContext);

  struct PidinStack *ppist = PidinStackParse(pcContext);

  if(!ppist)
  {

    return NULL;

  }


  struct symtab_IdentifierIndex *pidin = PidinStackToPidinQueue(ppist);

  
  if(!pidin)
  {
    return NULL;
  }


  struct symtab_InputOutput *pio = InputOutputNewForType(iType);

  if(!pio)
  {
    return NULL;
  }


  pio->pidinField = pidin;


  return pio;

}






//-----------------------------------------------------------------------
/*
 *
 */
//-----------------------------------------------------------------------
int ActivationStep(struct ioMsg *piom){


  double *pdActivation = NULL;

  if(!piom)
    return -1;


  if(!piom->dValue)
  {

    //-
    //- First obtain the heccer activation variable. 
    //- 
 
    struct nsintegrator_type *pelnsintegrator
      = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

    struct neurospaces_integrator *pnsintegrator = pelnsintegrator->pnsintegrator;
    
    struct Heccer *pheccer = pnsintegrator->ppheccer[0];

    // pdActivation = piom->pdActivation = HeccerAddressVariable(pheccer, piom->iSerial,"activation");
  
  }
  else
  {
    //    pdActivation = piom->pdActivation;

  }



  //- now obtain the value in the Activation Message Field.

  struct PidinStack *ppist = PidinStackParse(piom->pcSourceSymbol);

  PidinStackUpdateCaches(ppist);

  struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);


  struct symtab_Parameters *ppar = 
    SymbolFindParameter(phsle, ppist, piom->pcSourceField);


  if(ppar && pdActivation)
  {
    double dFieldValue = ParameterResolveValue(ppar,ppist);
    (*pdActivation) += dFieldValue;

  }
  else
    return -1;
    
  return 1;

}



/*
 *
 *
 */
struct PidinStack *getRootedContext(char *pc)
{

  if(!pc)
    return NULL;

  char *pcCurrentElement = NULL;

  char *pcCurrentElementPath = NULL;


  if(pc[0] != '/')
  {

    Element *elmCurrentElement = GetElement(".");

    pcCurrentElement = Pathname(elmCurrentElement);

    pcCurrentElementPath = strdup(pcCurrentElement);

    if(strcmp(pcCurrentElement,"/") != 0)
    {

	strcat(pcCurrentElementPath,"/");
    }


    //char *pcName = strdup(pc);
    
    strcat(pcCurrentElementPath,pc);


  }
  else
  {

  }

    
  return PidinStackParse(pcCurrentElementPath);

}
