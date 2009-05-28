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


    {    "CaP/HH_activation",    "0.001391094927", },
    {    "CaP/HH_inactivation",  "0.9868968318",   },
    {    "CaT/HH_activation",    "0.03891870645",  },
    {    "CaT/HH_inactivation",  "0.08260212813",  },
    {    "K2/HH_activation",     "0.2046429639",   },
    {    "K2/HH_concentration",  "0.1666666667",   },
    {    "KA/HH_activation",     "0.08324405922",  },
    {    "KA/HH_inactivation",   "0.7495011708",   },
    {    "KC/HH_activation",     "0.06353185977",  },
    {    "KC/HH_concentration",  "0.009900990099", },
    {    "KM/HH_activation",     "0.03540844397",  },
    {    "Kdr/HH_activation",    "0.004501601101", },
    {    "Kdr/HH_inactivation",  "0.9999785878",   },
    {    "NaF/HH_activation",    "0.007840644937", },
    {    "NaF/HH_inactivation",  "0.2639777693",   },
    {    "NaP/HH_activation",    "0.04529308881",  },
    {    "h1/HH_activation",     "0.09618512922",  },
    {    "h2/HH_activation",     "0.02404628231",  },
    {    NULL, NULL,  },
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


  char *pcParameter = mapParameterString(pcField);

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


  char *pcParameter = mapParameterString(pcField);
  

  ParameterSetName(pparTop,pcParameter);
		       

  pparTop->uValue.dNumber = dNumber;
  ParameterSetType(pparTop,TYPE_PARA_NUMBER);


  pparTop->pparFirst = pparTop;


  BioComponentChangeParameter((struct symtab_BioComponent *)phsle,pparTop);
  
  return 1;


}








//----------------------------------------------------------------------------
/*!
 *   \fn struct ParameterMapper * mapParameter(char *pcField)
 *   \param pcField A field label from the GENESIS SLI.
 *   
 *   Map a GENESIS field name to the appropriate model-container
 *   parameter name.
 */
//----------------------------------------------------------------------------
char * mapParameterString(char *pcField){

    //- obtain info about the field name

    struct ParameterMapper *ppm = mapParameter(pcField);

    if (ppm)
    {
	return(ppm->pcModelContainer);
    }
    else
    {
	// I guess this is a memory leak?  Required because the SLI
	// does a free of pcField?

	// Currently, removing the strdup() gives three test errors.

	return(strdup(pcField));
    }
}


//----------------------------------------------------------------------------
/*!
 *   \fn struct ParameterMapper * mapParameter(char *pcField)
 *   \param pcField A field label from the GENESIS SLI.
 *   
 *   Obtain information about a GENESIS field name.
 */
//----------------------------------------------------------------------------
struct ParameterMapper * mapParameter(char *pcField){

    struct ParameterMapper ppm[] =
    {
	{	    "Cm",	"CM",	},
	{	    "Rm",	"RM",	},
	{	    "Ra",	"RA",	},
	{	    "initVm",	"Vm_init",	},
	{	    "Eleak",	"ELEAK",	},
	{	    "dia",	"DIA",	},
	{	    "len",	"LEN",	},
	{	    "inject",	"INJECT",	},
	{	    "Em",	"ELEAK",	},
	{	    "Ek",	"Erev",	},
	{	    "Gbar",	"G_MAX",	},
	{	    "gmax",	"G_MAX",	},
	{	    "Xpower",	"POWER",	},
	{	    "Ypower",	"POWER",	},
	{	    "Zpower",	"POWER",	},
	{	    "tau",	"TAU",	},
	{	    "tau1",	"TAU1",	},
	{	    "tau2",	"TAU2",	},
	{	    "thick",	"THICK",	},
	{	    "Ca_base",	"BASE",	},
	{	    "B",	"BETA",	},
	{	    NULL,	NULL,	},
    };

    //- set default result: failure

    struct ParameterMapper *ppmResult = NULL;

    //- loop over all known parameters

    int i;

    for (i = 0 ; ppm[i].pcSLI ; i++)
    {
	//- if field name matches

	if (0 == strcmp(pcField, ppm[i].pcSLI))
	{
	    //- set result: model-container parameter name

	    ppmResult = &ppm[i];

	    break;
	}
    }

    //- return result

    return ppmResult;
}


//------------------------------------------------------------------
/*!
 *
 */
//------------------------------------------------------------------
struct symtab_HSolveListElement * lookupGate(char *pcName, char *pcField)
{


  struct symtab_HSolveListElement *phsle = NULL;


  struct PidinStack *ppist  = getRootedContext(pcName); //PidinStackParse(pcName);



  struct PidinStack *ppistCopy = PidinStackDuplicate(ppist);

  
  // \todo the mapping Xpower -> HH_activation is coded here and in NeurospacesSetField().
  if(!strcmp(pcField,"X") || !strcmp(pcField,"Xpower"))
  {

    phsle = PidinStackPushStringAndLookup(ppistCopy,"HH_activation");


  }
  else if(!strcmp(pcField,"Y") || !strcmp(pcField,"Ypower"))
  {
      // \todo the mapping Ypower -> HH_inactivation is coded here and in NeurospacesSetField().
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



    struct PidinStack *ppist  = getRootedContext(pcName); // PidinStackParse(pcName);


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



//------------------------------------------------------------------
/*
 *
 *
 */
//-------------------------------------------------------------------
char *getRootedPathname(char *pc)
{

  char pcBuff[1024];

  char *pcCurrentElement = NULL;




  if(pc[0] != '/')
  {

    Element *elmCurrentElement = GetElement(".");

    pcCurrentElement = Pathname(elmCurrentElement);


    strcpy(&pcBuff[0],pcCurrentElement);

    //    pcCurrentElementPath = strdup(pcCurrentElement);

    if(strcmp(pcCurrentElement,"/") != 0)
    {

	strcat(pcBuff,"/");
    }


    //char *pcName = strdup(pc);
    
    strcat(pcBuff,pc);

    return strdup(pcBuff);


  }
  else
  {
    //
    // if rooted just return a copy
    //
    return strdup(pc);
  }


}


//------------------------------------------------------------------
/*
 *
 *
 */
//-------------------------------------------------------------------
struct PidinStack *getRootedContext(char *pc)
{

  if(!pc)
    return NULL;

  char *pcCurrentElementPath = getRootedPathname(pc);

  if(!pcCurrentElementPath)
    return NULL;
    
  struct PidinStack *ppistResult
      = PidinStackParse(pcCurrentElementPath);

  free(pcCurrentElementPath);

  PidinStackCompress(ppistResult);

  return(ppistResult);
}




