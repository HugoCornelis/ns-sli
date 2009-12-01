//------------------------------------------------------------------
/*!
 *  \file nssetfield.c
 *  \author Mando Rodriguez
 *
 *  File contains the code for setting element fields for model container
 *  objects that are referenced in the GENESIS namespace.
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>

#include "shell_func_ext.h"

#include <heccer/addressing.h>
#include "nsintegrator.h"
#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"






static struct symtab_GateKinetic *CreateGateKinetic(char *pcDirection);
static
struct symtab_HSolveListElement * CreateHHGate(
		 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName);
static struct symtab_ConcentrationGateKinetic *CreateConcGateKinetic(char *pcDirection);
static
struct symtab_HSolveListElement * CreateConcGate(
		 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName);



//------------------------------------------------------------------
/*!
 *  \fn struct symtab_HSolveListElemen *CreateHHGate(
                 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName)
 *  \param phsleChannel Pointer to the Channel to attach gates.
 *  \param pcName A name for the HH gate.
 *  \return A pointer to an HSolveListElement which had been appended to phsleChannel
 */
//------------------------------------------------------------------
static
struct symtab_HSolveListElement * CreateHHGate(
		 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName){


  //i
  //i Allocate an HH gate and set its parent to phsleTabChannel.
  //i
  struct symtab_HHGate *pgathh = HHGateCalloc();


  if(!pgathh)
    return NULL;





  struct symtab_IdentifierIndex *pidinHHGate = 
    IdinNewFromChars(pcName);



  if(!pidinHHGate)
    return NULL;


  SymbolSetName(&pgathh->bio.ioh.iol.hsle,pidinHHGate);

  SymbolAddChild(phsleChannel,&pgathh->bio.ioh.iol.hsle);

  
  //i
  //i Need to add a name for the forward and backward gate kinetics.
  //i "forward" and "backward" respectively, then make these
  //i the children of the HH Gate pgathh.
  //i
  struct symtab_GateKinetic *pgatkForward = 
    CreateGateKinetic("A");

  if(!pgatkForward)
    return NULL;

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle,
		 &pgatkForward->bio.ioh.iol.hsle);
  


  struct symtab_GateKinetic *pgatkBackward = 
    CreateGateKinetic("B");

  if(!pgatkBackward)
    return NULL;

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle,
		 &pgatkBackward->bio.ioh.iol.hsle);


  //- allocate a parameter for state_init

  // steady state is forward over backward steady states.

/*   struct symtab_Parameters *pparVmInit */
/*       = newParameter("..->Vm_init", SETPARA_FIELD); */

  struct symtab_Parameters *pparStateInit
      = newParameter("-1", SETPARA_NUM);

  ParameterSetName(pparStateInit, "state_init");

  BioComponentChangeParameter(&pgathh->bio, pparStateInit);

  return (struct symtab_HSolveListElement *)pgathh;

}



//------------------------------------------------------------------
/*!
 *  \fn struct symtab_HSolveListElement *CreateConcGate(
                 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName)
 *  \param phsleChannel Pointer to the Channel to attach gates.
 *  \param pcName  A name for the concentration gate.
 *  \return A pointer to an HSolveListElement which had been appended to phsleChannel
 *
 */
//------------------------------------------------------------------
static
struct symtab_HSolveListElement * CreateConcGate(
		 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName){


  //i
  //i Allocate an HH gate and set its parent to phsleTabChannel.
  //i
  struct symtab_HHGate *pgathh = HHGateCalloc();


  if(!pgathh)
    return NULL;



  struct symtab_IdentifierIndex *pidinHHGate = 
    IdinNewFromChars(pcName);



  if(!pidinHHGate)
    return NULL;


  SymbolSetName(&pgathh->bio.ioh.iol.hsle,pidinHHGate);

  SymbolAddChild(phsleChannel,&pgathh->bio.ioh.iol.hsle);

  
  //i
  //i Need to add a name for the forward and backward gate kinetics.
  //i "forward" and "backward" respectively, then make these
  //i the children of the HH Gate pgathh.
  //i
  struct symtab_ConcentrationGateKinetic *pconcgatkForward = 
    CreateConcGateKinetic("A");

  if(!pconcgatkForward)
    return NULL;

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle,
		 &pconcgatkForward->bio.ioh.iol.hsle);
  


  struct symtab_ConcentrationGateKinetic *pconcgatkBackward = 
    CreateConcGateKinetic("B");

  if(!pconcgatkBackward)
    return NULL;

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle,
		 &pconcgatkBackward->bio.ioh.iol.hsle);

  //- allocate a parameter for state_init

  // steady state is forward over backward steady states.

/*   struct symtab_Parameters *pparVmInit */
/*       = newParameter("..->Vm_init", SETPARA_FIELD); */

  struct symtab_Parameters *pparStateInit
      = newParameter("-1", SETPARA_NUM);

  ParameterSetName(pparStateInit, "state_init");

  BioComponentChangeParameter(&pgathh->bio, pparStateInit);


  return (struct symtab_HSolveListElement *)pgathh;

}


//------------------------------------------------------------------
/*
 * \fn static struct symtab_GateKinetic *CreateGateKinetic(char *pcDirection)
 */
//------------------------------------------------------------------
static struct symtab_GateKinetic *CreateGateKinetic(char *pcDirection){


  struct symtab_GateKinetic *pgatk;


  struct symtab_IdentifierIndex *pidinDirection;

  
 
  pidinDirection = IdinNewFromChars(pcDirection);


  if(!pidinDirection)
    return NULL;


  pgatk = GateKineticCalloc();

  if(!pgatk)
    return NULL;


  SymbolSetName(&pgatk->bio.ioh.iol.hsle,pidinDirection);

  return pgatk;

}





//------------------------------------------------------------------
/*
 * \fn static struct symtab_GateKinetic *CreateConcGateKinetic(char *pcDirection)
 */
//------------------------------------------------------------------
static struct symtab_ConcentrationGateKinetic *CreateConcGateKinetic(char *pcDirection){


  struct symtab_ConcentrationGateKinetic *pconcgatk;


  struct symtab_IdentifierIndex *pidinDirection;

  
 
  pidinDirection = IdinNewFromChars(pcDirection);


  if(!pidinDirection)
    return NULL;


  pconcgatk =  ConcentrationGateKineticCalloc();

  if(!pconcgatk)
    return NULL;


  SymbolSetName(&pconcgatk->bio.ioh.iol.hsle,pidinDirection);

  return pconcgatk;

}



//------------------------------------------------------------------
/*!
 *  \fn int NSSetField(struct symtab_HSolveListElement *phsle, 
			struct PidinStack *ppist,
			char *pcPathname, char *field, char *value)
 *  \return 0 on error, 1 on success.
 *  \param phsle A pointer to an Hsolve list element.
 *  \param ppist A Pidin stack for searching for child objects.
 *  \param pcPathname A string with the complete pathname of the object.
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
int NSSetField(struct symtab_HSolveListElement *phsle, 
	       struct PidinStack *ppist,
	       char *pcPathname, char *pcField, char *pcValue){
    
    struct PidinStack *ppistWorking = NULL;
    struct symtab_HSolveListElement *phsleWorking = NULL;
 
    char *pcOriginal = pcPathname;

    // \todo Mando there are many 'return' statements in this
    // function, can you solve the resulting memory leaks?

    //- do hsolve correction for fields

    if (undo_findsolvefield(&pcPathname, &pcField))
    {
	ppistWorking = PidinStackParse(pcPathname);

	phsleWorking = PidinStackLookupTopSymbol(ppistWorking);

	//- if heccers have already been created

	struct neurospaces_integrator  *pnsintegrator = getNsintegrator();

/* 	if (pnsintegrator->iModelRegistrations) */
	{
	    //- lookup the heccer object using the pathname before findsolvefield correction

	    struct Heccer *pheccer = LookupHeccerObject(pcOriginal);

	    //- if there is a heccer for this variable

	    //! note that when the sli_load gshell command is used, it
	    //! is possible that the heccer does not exist.

	    if (pheccer)
	    {
		//- address the variable

		char *pcParameter = mapParameterString(pcField);

		int iSerial = PidinStackToSerial(ppistWorking);

		double *pd = HeccerAddressVariable(pheccer, iSerial, pcParameter);

		if (pd)
		{
		    double d = atof(pcValue);

		    *pd = d;
		}
		else
		{
		    fprintf(stdout, "Warning cannot set field %s->%s after a RESET has been done, heccer cannot find it in its private memory.\n", pcPathname, pcField);
		}
	    }
	    else
	    {
		fprintf(stdout, "Warning cannot set field %s->%s after a RESET has been done, cannot find a solver for it.\n", pcPathname, pcField);
	    }
	}
    }
    else
    {
	pcPathname = strdup(pcPathname);

	pcField = strdup(pcField);

	ppistWorking = PidinStackDuplicate(ppist);

	phsleWorking = phsle;
    }

    //
    // -The parameter fields "Ik" and "Gk" are solved variables in 
    //  Heccer so they don't need a parameter to be set at all, thus they
    //  are ignored completely.
    //

    // \todo what if we have an script_out element that sets Ik every
    // time step?

    if(!phsleWorking || 
       !strcmp(pcField,"Ik") || 
       !strcmp(pcField,"Gk") )
	return 0;
  

    // \todo Mando: can you correct this: the following
    // fields are only available on solve elements, and should be
    // ignored for NS.

    if (strcmp(pcField, "comptmode") == 0)
    {
	// \todo ignored

	return 1;
    }
    else if (strcmp(pcField, "chanmode") == 0)
    {
	// \todo ignored or set heccer options?

	return 1;
    }
    else if (strcmp(pcField, "calcmode") == 0)
    {
	// \todo set heccer option: enable or disable interpolation

	return 1;
    }

    //! is this related to nernst elements ?

    if(instanceof_group(phsleWorking))
    {
  
	setParameter(ppistWorking, phsleWorking,pcField,pcValue,SETPARA_NUM);
	return 1;
    }

    //-
    //- Check the type on the phsleWorking object passed. For certain types
    //- we must add parameters to the child objects rather than the object
    //- itself.
    //-
    if (instanceof_channel(phsleWorking)){


	//-
	//- The HHGate is only allocated when we see an Xpower value 
	//- Greater than zero. 
	//- 
	//- Parameter Xpower is set in the HH gate object, which is
	//- nexted in the Channel.
	//- 
	//-    Channel -> 
	//-               HH_gate -parameter-> Xpower
	//-
	//- is the order we must traverse the stack to get to the object.. 
	//-
	if (strcmp(pcField, "Xpower") == 0){

	    //- if zero, no need to create a gate.
	    double dNumber = strtod(pcValue,NULL);

	    if(dNumber == 0.0)
		return 1;


	    struct PidinStack *ppistGate
		= lookupGate(pcPathname,"Xpower"); 

	    struct symtab_HSolveListElement *phsleGate
		= PidinStackLookupTopSymbol(ppistGate);


	    if(phsleGate) 
	    { 

		double dPower = SymbolParameterResolveValue(phsleGate, ppistGate, "POWER"); 

		printf("Warning: Field \"Xpower\" for '%s' has already been set to %i, new value is %s.\n",  
		       pcPathname,(int)dPower, pcValue);
	    }
	    else
	    {
		//-
		//- we create our HH gate. Function creates
		//- the gate, sets it as a child to phsleWorking,
		//- and returns a pointer to the gate.

		phsleGate = 
		    CreateHHGate(phsleWorking, "HH_activation");
	    }


	    if(!phsleGate)
		return 0;

	    int iResult = setParameter(ppistGate, phsleGate,pcField,pcValue,SETPARA_NUM);

	    PidinStackFree(ppistGate);

	    return(iResult);

	}
	else if (strcmp(pcField, "Ypower") == 0){


	    //- if zero, no need to create a gate.
	    double dNumber = strtod(pcValue,NULL);

	    if(dNumber == 0.0)
		return 1;
      


	    struct PidinStack *ppistGate
		= lookupGate(pcPathname,"Ypower"); 

	    struct symtab_HSolveListElement *phsleGate
		= PidinStackLookupTopSymbol(ppistGate);

	    if(phsleGate) 
	    { 

		double dPower = SymbolParameterResolveValue(phsleGate, ppistGate, "POWER"); 

		printf("Warning: Field \"Ypower\" for '%s' has already been set to %i, new value is %s.\n",  
		       pcPathname,(int)dPower, pcValue);
	    }
	    else
	    {
		phsleGate = 
		    CreateHHGate(phsleWorking, "HH_inactivation");
	    }

	    if(!phsleGate)
		return 0;

	    int iResult = setParameter(ppistGate, phsleGate,pcField,pcValue,SETPARA_NUM);

	    PidinStackFree(ppistGate);

	    return(iResult);


	}
	else if(strcmp(pcField,"Zpower") == 0){ 


	    //- if zero, no need to create a gate.
	    double dNumber = strtod(pcValue,NULL);

	    if(dNumber == 0.0)
		return 1;

	    struct PidinStack *ppistGate
		= lookupGate(pcPathname,"Zpower"); 

	    struct symtab_HSolveListElement *phsleGate
		= PidinStackLookupTopSymbol(ppistGate);

	    if(phsleGate) 
	    { 

		double dPower = SymbolParameterResolveValue(phsleGate, ppistGate, "POWER"); 

		printf("Warning: Field \"Zpower\" for '%s' has already been set to %i, new value is %s.\n",  
		       pcPathname,(int)dPower, pcValue);
	    } 
	    else
	    {
		phsleGate = 
		    CreateConcGate(phsleWorking, "HH_concentration");
	    }

	    if(!phsleGate)
		return 0;

	    struct symtab_HSolveListElement *phsleConc
		= PidinStackPushStringAndLookup(ppistWorking, "HH_concentration");

	    //- Here we set the state_init parameter. 
	    setStateInit(ppistWorking);

	    int iResult = setParameter(ppistGate, phsleGate,pcField,pcValue,SETPARA_NUM);

	    PidinStackFree(ppistGate);

	    return(iResult);


	}
	else if( strncmp(pcField,"Z_A->table",10) == 0 ){

	    //-
	    //- We're checking the field to see if it begins with 'Z'
	    //- which indicates a concentration table.
	    //-
	    //- Then we check to see if we need to add the table to the
	    //- A or B kinetic.
	    //-


	    //- fetch the forward gate
	    struct PidinStack *ppistA = PidinStackDuplicate(ppistWorking);


	    //- we must look up the concentration gate
	    struct symtab_HSolveListElement *phsleConc
		= PidinStackPushStringAndLookup(ppistA, "HH_concentration");
  
	    if(!phsleConc){
		struct symtab_HSolveListElement *phsleWorking
		    = PidinStackLookupTopSymbol(ppistWorking);

		struct symtab_HSolveListElement *phsleGate
		    = CreateConcGate(phsleWorking, "HH_concentration");
	    }


	    struct symtab_HSolveListElement *phsleA = 
		PidinStackPushStringAndLookup(ppistA,"A");
    
	    if(!phsleA){
		Error();
		fprintf(stdout,
			"Could not find forward gate kinetic for %s\n",
			pcPathname);

		PidinStackFree(ppistA);

		return 0;
	    }

	    int iResult = setParameter(ppistA, phsleA,&pcField[5],pcValue,SETPARA_NUM);

	    PidinStackFree(ppistA);

	    return(iResult);

	}
	else if( strncmp(pcField,"Z_B->table",10) == 0 ){


	    struct PidinStack *ppistB = PidinStackDuplicate(ppistWorking);


	    //- we must look up the concentration gate
	    struct symtab_HSolveListElement *phsleConc
		= PidinStackPushStringAndLookup(ppistB, "HH_concentration");
  
	    if(!phsleConc){
		struct symtab_HSolveListElement *phsleWorking
		    = PidinStackLookupTopSymbol(ppistWorking);

		struct symtab_HSolveListElement *phsleGate
		    = CreateConcGate(phsleWorking, "HH_concentration");
	    }


	    struct symtab_HSolveListElement *phsleB = 
		PidinStackPushStringAndLookup(ppistB,"B");
    
	    if(!phsleB){
		Error();
		fprintf(stdout,
			"Could not find backward gate kinetic for %s\n",
			pcPathname);
		return 0;
	    }

	    int iResult = setParameter(ppistB, phsleB,&pcField[5],pcValue,SETPARA_NUM);

	    PidinStackFree(ppistB);

	    return(iResult);
	}
	else if( strncmp(pcField,"X_B->table",10) == 0 ){


	    struct PidinStack *ppistB = PidinStackDuplicate(ppistWorking);

	
	    //- we must look up the HH gate
	    struct symtab_HSolveListElement *phsleActivation
		= PidinStackPushStringAndLookup(ppistB, "HH_activation");
  
	    if(!phsleActivation){
		struct symtab_HSolveListElement *phsleWorking
		    = PidinStackLookupTopSymbol(ppistWorking);

		struct symtab_HSolveListElement *phsleGate
		    = CreateHHGate(phsleWorking, "HH_activation");
	    }


	    struct symtab_HSolveListElement *phsleB = 
		PidinStackPushStringAndLookup(ppistB,"B");

	    if(!phsleB){
		Error();
		fprintf(stdout,
			"Could not find backward gate kinetic for %s\n",
			pcPathname);
		return 0;
	    }

	    int iResult = setParameter(ppistB, phsleB,&pcField[5],pcValue,SETPARA_NUM);

	    PidinStackFree(ppistB);

	    return(iResult);
	}
	else if( strncmp(pcField,"X_A->table",10) == 0 ){


	    struct PidinStack *ppistA = PidinStackDuplicate(ppistWorking);


	    //- we must look up the HH gate
	    struct symtab_HSolveListElement *phsleActivation
		= PidinStackPushStringAndLookup(ppistA, "HH_activation");
  
	    if(!phsleActivation){
		struct symtab_HSolveListElement *phsleWorking
		    = PidinStackLookupTopSymbol(ppistWorking);

		struct symtab_HSolveListElement *phsleGate
		    = CreateHHGate(phsleWorking, "HH_activation");
	    }



	    struct symtab_HSolveListElement *phsleA = 
		PidinStackPushStringAndLookup(ppistA,"A");
    
	    if(!phsleA){
		Error();
		fprintf(stdout,
			"Could not find forward gate kinetic for %s\n",
			pcPathname);
		return 0;
	    }

	    int iResult = setParameter(ppistA, phsleA,&pcField[5],pcValue,SETPARA_NUM);

	    PidinStackFree(ppistA);

	    return(iResult);
	}

	else if( strncmp(pcField,"Y_B->table",10) == 0 ){

      
	    struct PidinStack *ppistB = PidinStackDuplicate(ppistWorking);

	    //- we must look up the HH gate
	    struct symtab_HSolveListElement *phsleInactivation
		= PidinStackPushStringAndLookup(ppistB, "HH_inactivation");
  
	    if(!phsleInactivation){
		struct symtab_HSolveListElement *phsleWorking
		    = PidinStackLookupTopSymbol(ppistWorking);

		struct symtab_HSolveListElement *phsleGate
		    = CreateHHGate(phsleWorking, "HH_inactivation");
	    }


	    struct symtab_HSolveListElement *phsleB = 
		PidinStackPushStringAndLookup(ppistB,"B");
    
	    if(!phsleB){
		Error();
		fprintf(stdout,
			"Could not find backward gate kinetic for %s\n",
			pcPathname);
		return 0;
	    }

	    int iResult = setParameter(ppistB, phsleB,&pcField[5],pcValue,SETPARA_NUM);

	    PidinStackFree(ppistB);

	    return(iResult);
	}
	else if( strncmp(pcField,"Y_A->table",10) == 0 ){

      
	    struct PidinStack *ppistA = PidinStackDuplicate(ppistWorking);


	    //- we must look up the HH gate
	    struct symtab_HSolveListElement *phsleInactivation
		= PidinStackPushStringAndLookup(ppistA, "HH_inactivation");
  
	    if(!phsleInactivation){
		struct symtab_HSolveListElement *phsleWorking
		    = PidinStackLookupTopSymbol(ppistWorking);

		struct symtab_HSolveListElement *phsleGate
		    = CreateHHGate(phsleWorking, "HH_inactivation");
	    }
  

	    struct symtab_HSolveListElement *phsleA = 
		PidinStackPushStringAndLookup(ppistA,"A");
    
	    if(!phsleA){
		Error();
		fprintf(stdout,
			"Could not find forward gate kinetic for %s\n",
			pcPathname);
		return 0;
	    }

	    int iResult = setParameter(ppistA, phsleA,&pcField[5],pcValue,SETPARA_NUM);

	    PidinStackFree(ppistA);

	    return(iResult);
	}



	else if(!strcmp(pcField,"X_init"))
	{


	    //- Return is it's just zero, not sure if this is right
	    double dNumber = strtod(pcValue,NULL);

	    if(dNumber == 0.0)
		return 1;

	    //
	    // A bit dangerous since I'm not making sure that HH_activation
	    // has been created first. Will safty check it later.
	    //
	    struct PidinStack *ppistGate = PidinStackDuplicate(ppistWorking);

	    struct symtab_HSolveListElement *phsleGate = 
		PidinStackPushStringAndLookup(ppistGate,"HH_activation");
   
	    if(!phsleGate)
		return 0;

	    int iResult = setParameter(ppistGate, phsleGate,"state_init",pcValue,SETPARA_NUM);

	    PidinStackFree(ppistGate);

	    return(iResult);
	}
	else if(!strcmp(pcField,"Y_init"))
	{


	    //- Return is it's just zero, not sure if this is right
	    double dNumber = strtod(pcValue,NULL);

	    if(dNumber == 0.0)
		return 1;

	    //
	    // A bit dangerous since I'm not making sure that HH_activation
	    // has been created first. Will safty check it later.
	    //
	    struct PidinStack *ppistGate = PidinStackDuplicate(ppistWorking);

	    struct symtab_HSolveListElement *phsleGate = 
		PidinStackPushStringAndLookup(ppistGate,"HH_inactivation");

	    if(!phsleGate)
		return 0;

	    int iResult = setParameter(ppistGate, phsleGate,"state_init",pcValue,SETPARA_NUM);

	    PidinStackFree(ppistGate);

	    return(iResult);
	}
	else if(!strcmp(pcField,"Z_init"))
	{


	    //- Return is it's just zero, not sure if this is right
	    double dNumber = strtod(pcValue,NULL);

	    if(dNumber == 0.0)
		return 1;

	    //
	    // A bit dangerous since I'm not making sure that HH_activation
	    // has been created first. Will safty check it later.
	    //
	    struct PidinStack *ppistGate = PidinStackDuplicate(ppistWorking);

	    struct symtab_HSolveListElement *phsleGate = 
		PidinStackPushStringAndLookup(ppistGate,"HH_concentration");
   

	    if(!phsleGate)
		return 0;

	    int iResult = setParameter(ppistGate, phsleGate,"state_init",pcValue,SETPARA_NUM);

	    PidinStackFree(ppistGate);

	    return(iResult);
	}
	else if(!strcmp(pcField,"instant"))
	{
	    //- set default result: success

	    int iResult = 1;

	    //- return is it's just zero, not sure if this is right

	    int iValue = atoi(pcValue);

	    if (iValue == 0.0)
	    {
		return 1;
	    }

	    //- if it sets the instantaneous mode for the X gate

	    if (iValue & 1)
	    {
		//
		// A bit dangerous since I'm not making sure that HH_activation
		// has been created first. Will safty check it later.
		//

		struct PidinStack *ppistGate = PidinStackDuplicate(ppistWorking);

		struct symtab_HSolveListElement *phsleGate
		    = PidinStackPushStringAndLookup(ppistGate,"HH_activation");
   
		if (!phsleGate)
		{
		    return 0;
		}

		//- set the corresponding parameter

		iResult = iResult && setParameter(ppistGate, phsleGate, "instantaneous", "yes", SETPARA_STRING);

		PidinStackFree(ppistGate);
	    }

	    //- if it sets the instantaneous mode for the Y gate

	    if (iValue & 2)
	    {
		//
		// A bit dangerous since I'm not making sure that HH_activation
		// has been created first. Will safty check it later.
		//

		struct PidinStack *ppistGate = PidinStackDuplicate(ppistWorking);

		struct symtab_HSolveListElement *phsleGate
		    = PidinStackPushStringAndLookup(ppistGate,"HH_inactivation");
   
		if (!phsleGate)
		{
		    return 0;
		}

		//- set the corresponding parameter

		iResult = iResult && setParameter(ppistGate, phsleGate, "instantaneous", "yes", SETPARA_STRING);

		PidinStackFree(ppistGate);
	    }

	    //- if it sets the instantaneous mode for the Z gate

	    if (iValue & 4)
	    {
		//
		// A bit dangerous since I'm not making sure that HH_activation
		// has been created first. Will safty check it later.
		//

		struct PidinStack *ppistGate = PidinStackDuplicate(ppistWorking);

		struct symtab_HSolveListElement *phsleGate
		    = PidinStackPushStringAndLookup(ppistGate,"HH_concentration");
   
		if (!phsleGate)
		{
		    return 0;
		}

		//- set the corresponding parameter

		iResult = iResult && setParameter(ppistGate, phsleGate, "instantaneous", "yes", SETPARA_STRING);

		PidinStackFree(ppistGate);
	    }

	    return(iResult);
	}
    }
    else if (instanceof_segment(phsleWorking))
    {
/* 	struct symtab_Parameters *pparSurface = NULL; */

	if (strcmp(pcField, "len") == 0)
	{
	    double d = strtod(pcValue, NULL);

	    if (d == 0.0)
	    {
		SymbolSetOptions(phsleWorking, FLAG_SEGMENTER_SPHERICAL);
	    }
	    else
	    {
		SymbolSetOptions(phsleWorking, SymbolGetOptions(phsleWorking) & ~(FLAG_SEGMENTER_SPHERICAL));
	    }

/* 	    pparSurface = SymbolGetParameter(phsleWorking, ppistWorking, "SURFACE"); */
	}
	else if (strcmp(pcField, "dia") == 0)
	{
/* 	    pparSurface = SymbolGetParameter(phsleWorking, ppistWorking, "SURFACE"); */
	}

/* 	if (pparSurface) */
/* 	{ */
/* 	    double dSurface = SegmentGetSurface((struct symtab_Segment *)phsleWorking, ppistWorking); */

/* 	    pparSurface->uValue.dNumber = dSurface; */
/* 	} */
    }

    return setParameter(ppistWorking, phsleWorking, pcField, pcValue, 0);

}





