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
#include "neurospaces/symbolvirtual_protos.h"
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

      setParameter(ppist, phsle, "state_init",
		   GateStateTableInitializers[i].pcValue,
		   SETPARA_NUM);

      return 1;

    }
 

    
  }


  return 1;

}
//- end setStateInit -------------------------------------------------------------------






//----------------------------------------------------------------------------
/*!
 *  \fn int newParameter(char *pcValue, int iType)
 *
 * The newParameter() function allocates a parameter and associates a
 * value with it.  Depending on the type, the parameter can be fixed,
 * scalable or have other properties.  The mapParameter() function
 * defines the essential properties of the parameters.  See the code
 * for more details.
 *
 */
//----------------------------------------------------------------------------

struct symtab_Parameters *newParameter(char *pcValue, int iType)
{
    //- set default result: failure

    struct symtab_Parameters *pparResult = NULL;

    if (iType == SETPARA_GENESIS2)
    {
	struct symtab_Parameters *pparScale = ParameterNewFromNumber("scale", 1.0);

	double dValue = atof(pcValue);

	struct symtab_Parameters *pparValue = ParameterNewFromNumber("value", dValue);

	//- link parameters into a list

	pparScale->pparFirst = pparScale;
	pparScale->pparNext = pparValue;

	pparValue->pparFirst = pparScale;
	pparValue->pparNext = NULL;

	struct symtab_Function *pfun = FunctionCalloc();

	FunctionSetName(pfun, "GENESIS2");
	FunctionAssignParameters(pfun, pparScale);

	//- assign the scaling function to the parameter pparResult 

	pparResult = ParameterCalloc();

	pparResult->uValue.pfun = pfun;

	ParameterSetType(pparResult, TYPE_PARA_FUNCTION);
    }
    else if( iType == SETPARA_HERE )
    {
	pparResult = ParameterCalloc();
  
	pparResult->uValue.dNumber = FLT_MAX; /* dHere; */
	ParameterSetType(pparResult,TYPE_PARA_NUMBER);

    }
    else if( iType == SETPARA_NUM )
    {
	pparResult = ParameterCalloc();

	double dValue = strtod(pcValue,NULL);

	pparResult->uValue.dNumber = dValue;
	ParameterSetType(pparResult,TYPE_PARA_NUMBER);

    }
    else if( iType == SETPARA_FIELD )
    {
	pparResult = ParameterCalloc();

	struct PidinStack *ppistValue  = PidinStackParse(pcValue);

	struct symtab_IdentifierIndex *pidinValue = 
	    PidinStackToPidinQueue(ppistValue);

	pparResult->uValue.pidin = pidinValue;
	ParameterSetType(pparResult,TYPE_PARA_FIELD);

    }
    else
    {
	pparResult = ParameterCalloc();

	pparResult->uValue.pcString = pcValue;
	ParameterSetType(pparResult,TYPE_PARA_STRING);

    }


    //- return result

    return(pparResult);
}


//----------------------------------------------------------------------------
/*!
 *  \fn int setParameter(struct PidinStack *ppist,
 *		 struct symtab_HSolveListElement *phsle,
 *		 char *pcField, char *pcValue,int iType)
 *
 * The setParameter() function associates both SLI fields and model
 * container parameters with values.  The mapParameter() function is
 * called to convert SLI field names to model container parameter
 * names.  A model container parameter is allocated using
 * newParameter() and attached to the symbol using
 * BioComponentChangeParameter().
 *
 */
//----------------------------------------------------------------------------
int setParameter(struct PidinStack *ppist,
		 struct symtab_HSolveListElement *phsle,
		 char *pcField, char *pcValue,int iType){

  int iFlags = 0;

  double dHere = FLT_MAX;

  struct ParameterMapper *ppm = mapParameter(pcField);

  if (ppm)
  {
      iFlags = ppm->iFlags;
  }

  if (iFlags & SLI_PARAMETER_SCALED)
  {
      if (iType == 0)
      {
/* 	  fprintf(stdout, "changing type to SETPARA_GENESIS2 for %s\n", pcField); */

	  iType = SETPARA_GENESIS2;
      }
  }
  else if (iFlags & SLI_PARAMETER_SCALED_TO_COMPARTMENT_SURFACE)
  {
      if (iType == 0)
      {
	  //t lookup compartment
	  //t lookup compartment surface
	  //t convert actual to specific value
	  //t set parameter as number

	  //- lookup compartment

	  struct PidinStack *ppistComp = SymbolFindParentSegment(phsle, ppist);

/* 	  if (ppistComp) */
/* 	  { */
/* 	      struct symtab_HSolveListElement *phsleComp */
/* 		  = PidinStackLookupTopSymbol(ppistComp); */

/* 	      double dSurface = SymbolParameterResolveValue(phsleComp, ppistComp, "SURFACE"); */

/* 	      if (dSurface != FLT_MAX) */
/* 	      { */
/* 		  dHere = atof(pcValue); */

/* 		  dHere /= dSurface; */

/* 		  iType = SETPARA_HERE; */
/* 	      } */
/* 	      else */
/* 	      { */
/* 		  fprintf(stdout, "changing type to SETPARA_GENESIS2 for %s -- no segment surface defined\n", pcField); */

/* 		  iType = SETPARA_GENESIS2; */
/* 	      } */
/* 	  } */
/* 	  else */
	  {
/* 	      fprintf(stdout, "changing type to SETPARA_GENESIS2 for %s -- no parent segment found\n", pcField); */

	      iType = SETPARA_GENESIS2;
	  }
      }
  }
  else if (iFlags & SLI_PARAMETER_SCALED_TO_COMPARTMENT_LENGTH)
  {
      if (iType == 0)
      {
/* 	  fprintf(stdout, "changing type to SETPARA_GENESIS2 for %s\n", pcField); */

	  iType = SETPARA_GENESIS2;
      }
  }
  else if (iFlags & SLI_PARAMETER_NUMBER)
  {
      if (iType == 0)
      {
/* 	  fprintf(stdout, "changing type to SETPARA_NUM for %s\n", pcField); */

	  iType = SETPARA_NUM;
      }
  }

  //-
  //- check for the GENESIS2 flag, if on then
  //- we mut allocate and set a GEN2 function parameter.
  //-

  struct symtab_Parameters *pparTop = NULL;

/*   if( iType == SETPARA_GENESIS2 ) */
  {
      pparTop = newParameter(strdup(pcValue), iType);
  } 

  if (ppm)
  {
      ParameterSetName(pparTop, ppm->pcModelContainer);
  }
  else
  {
      ParameterSetName(pparTop, strdup(pcField));
  }


 

  BioComponentChangeParameter((struct symtab_BioComponent *)phsle,pparTop);
  
  return 1;


}


//-------------------------------------------------------------
/*!
 *  \fn int setParameterNumber(struct PidinStack *ppist,
 *			struct symtab_HSolveListElement *phsle, 
 *                               char *pcField, double dNumber)
 *
 *   Function to to set a number without the overhead of 
 *   reconverting it back into a string for setParameter().
 *   
 */
//-------------------------------------------------------------
int setParameterNumber(struct PidinStack *ppist,
		       struct symtab_HSolveListElement *phsle,
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
 *   Obtain information about a GENESIS field name and its
 *   corresponding Neurospaces model-container parameter name.
 */
//----------------------------------------------------------------------------
struct ParameterMapper * mapParameter(char *pcField){

    static struct ParameterMapper ppm[] =
    {
	{	    "Cm",	"CM",	SLI_PARAMETER_SCALED_TO_COMPARTMENT_SURFACE | SLI_PARAMETER_NUMBER,	},
	{	    "Rm",	"RM",	SLI_PARAMETER_SCALED_TO_COMPARTMENT_SURFACE | SLI_PARAMETER_NUMBER,	},
	{	    "Ra",	"RA",	SLI_PARAMETER_SCALED_TO_COMPARTMENT_LENGTH | SLI_PARAMETER_NUMBER,	},
	{	    "initVm",	"Vm_init",	SLI_PARAMETER_NUMBER,	},
	{	    "Eleak",	"ELEAK",	SLI_PARAMETER_NUMBER,	},
	{	    "dia",	"DIA",	SLI_PARAMETER_NUMBER,	},
	{	    "len",	"LENGTH",	SLI_PARAMETER_NUMBER,	},
	{	    "inject",	"INJECT",	SLI_PARAMETER_NUMBER,	},
	{	    "Em",	"ELEAK",	SLI_PARAMETER_NUMBER,	},
	{	    "Ek",	"Erev",	SLI_PARAMETER_NUMBER,	},
	{	    "Gbar",	"G_MAX",	SLI_PARAMETER_SCALED_TO_COMPARTMENT_SURFACE | SLI_PARAMETER_NUMBER,	},
	{	    "gmax",	"G_MAX",	SLI_PARAMETER_SCALED_TO_COMPARTMENT_SURFACE | SLI_PARAMETER_NUMBER,	},
	{	    "Xpower",	"POWER",	SLI_PARAMETER_NUMBER,	},
	{	    "Ypower",	"POWER",	SLI_PARAMETER_NUMBER,	},
	{	    "Zpower",	"POWER",	SLI_PARAMETER_NUMBER,	},
	{	    "tau",	"TAU",	SLI_PARAMETER_NUMBER,	},
	{	    "tau1",	"TAU1",	SLI_PARAMETER_NUMBER,	},
	{	    "tau2",	"TAU2",	SLI_PARAMETER_NUMBER,	},
	{	    "thick",	"THICK",	SLI_PARAMETER_NUMBER,	},
	{	    "Ca_base",	"BASE",	SLI_PARAMETER_NUMBER,	},
	{	    "B",	"BETA",	SLI_PARAMETER_SCALED | SLI_PARAMETER_NUMBER,	},
	{	    "concen_init",	"concen_init",	SLI_PARAMETER_NUMBER,	},
	{	    "x",	"x",	SLI_PARAMETER_NUMBER,	},
	{	    "y",	"y",	SLI_PARAMETER_NUMBER,	},
	{	    "z",	"z",	SLI_PARAMETER_NUMBER,	},
	{	    "thresh",	"THRESHOLD",	SLI_PARAMETER_NUMBER,	},
	{	    "abs_refract",	"REFRACTORY",	SLI_PARAMETER_NUMBER,	},
	{	    NULL,	NULL,	0,	},
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
	    //- set result: entry with parameter information

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
struct PidinStack * lookupGate(char *pcName, char *pcField)
{


  struct PidinStack *ppistResult  = getRootedContext(pcName); //PidinStackParse(pcName);



  // \todo the mapping Xpower -> HH_activation is coded here and in NeurospacesSetField().
  if(strcmp(pcField,"X") == 0
     || strcmp(pcField,"Xpower") == 0)
  {

      PidinStackPushString(ppistResult,"HH_activation");


  }
  else if(strcmp(pcField,"Y") == 0
	  || strcmp(pcField,"Ypower") == 0)
  {
      // \todo the mapping Ypower -> HH_inactivation is coded here and in NeurospacesSetField().
      PidinStackPushString(ppistResult,"HH_inactivation");
    

  }
  else if(strcmp(pcField,"Z") == 0
	  || strcmp(pcField,"Zpower") == 0)
  {

      PidinStackPushString(ppistResult,"HH_concentration");
    

  }
  
  return ppistResult;


}




//-----------------------------------------------------------------
/*!
 *
 */
//-----------------------------------------------------------------
struct PidinStack * getGateContext(char *pcName, char *pcField, char *pcAorB)
{



    struct PidinStack *ppistResult  = lookupGate(pcName, pcField);

    if(!strcmp(pcAorB,"A") || !strcmp(pcAorB,"B"))
    {

	PidinStackPushString(ppistResult, pcAorB);

    }


    return ppistResult;


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
    
/*     struct Heccer *pheccer = pnsintegrator->ppheccer[0]; */

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
	pcCurrentElement = WorkingElementName();

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


