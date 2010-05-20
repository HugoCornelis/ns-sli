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





int
ChannelSetField
(struct symtab_HSolveListElement *phsleWorking,
 struct PidinStack *ppistWorking,
 char *pcPathname,
 char *pcField,
 char *pcValue);


static
struct symtab_HSolveListElement * CreateGate(
		 struct symtab_HSolveListElement *phsleChannel, 
		 char *pcName);
static
struct symtab_HSolveListElement *
CreateGateKinetic(char *pcDirection, int iConcentration);


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
struct symtab_HSolveListElement * CreateGate(
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

  struct symtab_HSolveListElement *phsleForward = NULL;

  if (strcmp(pcName, "HH_concentration") == 0)
  {
      phsleForward = CreateGateKinetic("A", 1);
  }
  else
  {
      phsleForward = CreateGateKinetic("A", 0);
  }

  if (!phsleForward)
  {
      return(NULL);
  }

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle, phsleForward);
  
  struct symtab_HSolveListElement *phsleBackward = NULL;

  if (strcmp(pcName, "HH_concentration") == 0)
  {
      phsleBackward = CreateGateKinetic("B", 1);
  }
  else
  {
      phsleBackward = CreateGateKinetic("B", 0);
  }

  if (!phsleBackward)
  {
      return(NULL);
  }

  SymbolAddChild(&pgathh->bio.ioh.iol.hsle, phsleBackward);


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


static
struct symtab_HSolveListElement *
CreateGateKinetic
(char *pcDirection, int iConcentration)
{
    struct symtab_HSolveListElement *phsle;
    struct symtab_IdentifierIndex *pidinDirection
	= IdinNewFromChars(pcDirection);

    if (!pidinDirection)
	return NULL;

    if (iConcentration)
    {
	phsle = (struct symtab_HSolveListElement *)ConcentrationGateKineticCalloc();
    }
    else
    {
	phsle = (struct symtab_HSolveListElement *)GateKineticCalloc();
    }

    if (!phsle)
    {
	return NULL;
    }

    SymbolSetName(phsle, pidinDirection);

    return(phsle);
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

    //- Check the type on the phsleWorking object passed. For certain types
    //- we must add parameters to the child objects rather than the object
    //- itself.

    //! is this related to nernst elements ?

    if (instanceof_group(phsleWorking))
    {
	return(setParameter(ppistWorking, phsleWorking,pcField,pcValue,SETPARA_NUM));
    }
    else if (instanceof_channel(phsleWorking))
    {
	return(ChannelSetField(phsleWorking, ppistWorking, pcPathname, pcField, pcValue));
    }

    return setParameter(ppistWorking, phsleWorking, pcField, pcValue, 0);

    // \todo memory leak on ppistWorking
}


static
int
GateSetField
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 char *pcPathname,
 char *pcField,
 char *pcValue,
 char *pcGateName)
{
    //- if zero, no need to create a gate.
    double dNumber = strtod(pcValue, NULL);

    // \note: if these lines are removed, the settings of the channel
    // can become unrecognizable by heccer.  For example, the channel
    // can have an empty inactivation gate, but that will corrupt the
    // CHANNEL_TYPE parameter.

    if(dNumber == 0.0)
	return 1;


    struct PidinStack *ppistGate
	= PidinStackDuplicate(ppist);

    struct symtab_HSolveListElement *phsleGate
	= PidinStackPushStringAndLookup(ppistGate, pcGateName);


    if (phsleGate) 
    {
/* 	double dField = SymbolParameterResolveValue(phsleGate, ppistGate, pcField); */

/* 	printf("Warning: Field \"%s\" for '%s' has already been set to %g, new value is %s.\n",   */
/* 	       pcField, pcPathname, dField, pcValue); */
    }
    else
    {
	//- create the HH gate, sets it as a child to phsle,
	//- and returns a pointer to it.

	phsleGate = CreateGate(phsle, pcGateName);
    }

    if(!phsleGate)
	return 0;

    if (strcmp(pcGateName, "HH_concentration") == 0)
    {
	//- set the state_init parameter.

	setStateInit(ppistGate);
    }

    int iResult = setParameter(ppistGate, phsleGate, pcField, pcValue, SETPARA_NUM);

    PidinStackFree(ppistGate);

    return(iResult);

}

static
int
TableSetField
(struct symtab_HSolveListElement *phsle,
 struct PidinStack *ppist,
 char *pcPathname,
 char *pcField,
 char *pcValue,
 char *pcGateName)
{
    //- check the field to see if it begins with 'Z'
    //- which indicates a concentration table.
    //-
    //- Then we check to see if we need to add the table to the
    //- A or B kinetic.


    //- fetch the forward / backward kinetic

    struct PidinStack *ppistKinetic = PidinStackDuplicate(ppist);


    //- we must look up the concentration gate

    struct symtab_HSolveListElement *phsleGate
	= PidinStackPushStringAndLookup(ppistKinetic, pcGateName);
  
    if (!phsleGate)
    {
	phsleGate = CreateGate(phsle, pcGateName);
    }

    char pcKinetic[10];

    pcKinetic[0] = pcField[2];
    pcKinetic[1] = '\0';

    struct symtab_HSolveListElement *phsleKinetic
	= PidinStackPushStringAndLookup(ppistKinetic, pcKinetic);
    
    if (!phsleKinetic)
    {
	Error();
	fprintf(stdout,
		"Could not find %s gate kinetic for %s\n",
		pcKinetic,
		pcPathname);

	PidinStackFree(ppistKinetic);

	return 0;
    }

    int iResult = setParameter(ppistKinetic, phsleKinetic, &pcField[5], pcValue, SETPARA_NUM);

    PidinStackFree(ppistKinetic);

    return(iResult);
}

int
ChannelSetField
(struct symtab_HSolveListElement *phsleWorking,
 struct PidinStack *ppistWorking,
 char *pcPathname,
 char *pcField,
 char *pcValue)
{
    if(!strcmp(pcField, "instant"))
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


    {
	struct g2_g3_channel_field_mapper
	{
	    char *pcG2;
	    int iLength;
	    char *pcGateName;
	    int (*ChannelMapField)
		(struct symtab_HSolveListElement *phsle,
		 struct PidinStack *ppist,
		 char *pcPathname,
		 char *pcField,
		 char *pcValue,
		 char *pcGateName);
	};

	static struct g2_g3_channel_field_mapper pggcfm[] =
	    {
		"X_init", -1, "HH_activation", GateSetField,
		"Xpower", -1, "HH_activation", GateSetField,
		"Y_init", -1, "HH_inactivation", GateSetField,
		"Ypower", -1, "HH_inactivation", GateSetField,
		"Z_init", -1, "HH_concentration", GateSetField,
		"Zpower", -1, "HH_concentration", GateSetField,
		"instant", -1, NULL, GateSetField,

		"X_A->table", 10, "HH_activation", TableSetField,
		"X_B->table", 10, "HH_activation", TableSetField,
		"Y_A->table", 10, "HH_inactivation", TableSetField,
		"Y_B->table", 10, "HH_inactivation", TableSetField,
		"Z_A->table", 10, "HH_concentration", TableSetField,
		"Z_B->table", 10, "HH_concentration", TableSetField,

		"X_A->calc_mode", 14, "HH_activation", TableSetField,
		"X_B->calc_mode", 14, "HH_activation", TableSetField,
		"Y_A->calc_mode", 14, "HH_inactivation", TableSetField,
		"Y_B->calc_mode", 14, "HH_inactivation", TableSetField,
		"Z_A->calc_mode", 14, "HH_concentration", TableSetField,
		"Z_B->calc_mode", 14, "HH_concentration", TableSetField,

		NULL, -1, NULL, NULL,
	    };

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

	int i;

	for ( i = 0 ; pggcfm[i].pcG2 ; i++)
	{
	    int iLength = pggcfm[i].iLength;

	    if (iLength == -1)
	    {
		iLength = strlen(pggcfm[i].pcG2);
	    }

	    if (strncmp(pcField, pggcfm[i].pcG2, iLength) == 0)
	    {
		return(pggcfm[i].ChannelMapField(phsleWorking, ppistWorking, pcPathname, pcField, pcValue, pggcfm[i].pcGateName));
	    }
	}
    }

    return setParameter(ppistWorking, phsleWorking, pcField, pcValue, 0);
}


