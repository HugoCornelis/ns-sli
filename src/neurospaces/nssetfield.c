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
#include "shell_func_ext.h"

#include "nsintegrator.h"
#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"








//------------------------------------------------------------------
/*!
 *  \fn int NeurospacesSetField(struct symtab_HSolveListElement *phsle, 
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
int NeurospacesSetField(struct symtab_HSolveListElement *phsle, 
			struct PidinStack *ppist,
			char *pcPathname, char *pcField, char *value){

    struct PidinStack *ppistWorking = NULL;
    struct symtab_HSolveListElement *phsleWorking = NULL;
 
    // \todo Mando there are many 'return' statements in this
    // function, can you solve the resulting memory leaks?

    //- do hsolve correction for fields

    if (undo_findsolvefield(&pcPathname, &pcField))
    {
	ppistWorking = PidinStackParse(pcPathname);

	phsleWorking = PidinStackLookupTopSymbol(ppistWorking);
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

  if(instanceof_group(phsleWorking))
  {
  
    setParameter(phsleWorking,pcField,value,SETPARA_NUM);
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



      struct symtab_HSolveListElement *phsleGate = 
        lookupGate(pcPathname,"Xpower"); 


      if(phsleGate) 
      { 

        double dPower = SymbolParameterResolveValue(phsleGate, ppistWorking, "POWER"); 

        printf("Warning: Field \"Xpower\" for '%s' has already been set to %i.\n",  
 	      pcPathname,(int)dPower);  

        return 1; 
      }



     //- if zero, no need to create a gate.
      double dNumber = strtod(value,NULL);

      if(dNumber == 0.0)
	return 1;

      //-
      //- we create our HH gate. Function creates
      //- the gate, ssets it as a child to phsleWorking,
      //- and returns a pointer to the gate.
      phsleGate = 
	  CreateHHGate(phsleWorking, "HH_activation");

      if(!phsleGate)
	return 0;

      return setParameter(phsleGate,pcField,value,SETPARA_GENESIS2);


    }
    else if (strcmp(pcField, "Ypower") == 0){



    struct symtab_HSolveListElement *phsleGate = 
      lookupGate(pcPathname,"Ypower"); 


      if(phsleGate) 
      { 

        double dPower = SymbolParameterResolveValue(phsleGate, ppistWorking, "POWER"); 

        printf("Warning: Field \"Ypower\" for '%s' has already been set to %i.\n",  
 	      pcPathname,(int)dPower);  

        return 1; 
      } 

     //- if zero, no need to create a gate.
      double dNumber = strtod(value,NULL);

      if(dNumber == 0.0)
	return 1;
      

      phsleGate = 
	  CreateHHGate(phsleWorking, "HH_inactivation");

      if(!phsleGate)
	return 0;

      return setParameter(phsleGate,pcField,value,SETPARA_GENESIS2);


    }
    else if(strcmp(pcField,"Zpower") == 0){ 


    struct symtab_HSolveListElement *phsleGate = 
	lookupGate(pcPathname,"Zpower"); 


      if(phsleGate) 
      { 

        double dPower = SymbolParameterResolveValue(phsleGate, ppistWorking, "POWER"); 

        printf("Warning: Field \"Zpower\" for '%s' has already been set to %i.\n",  
 	      pcPathname,(int)dPower);  

        return 1; 
      } 


     //- if zero, no need to create a gate.
      double dNumber = strtod(value,NULL);

      if(dNumber == 0.0)
	return 1;
      

      
      phsleGate = 
	CreateConcGate(phsleWorking, "HH_concentration");
      
      
      if(!phsleGate)
	return 0;


      return setParameter(phsleGate,pcField,value,SETPARA_GENESIS2);


      return 1; 


    }
    else if( strncmp(pcField,"Z_A->table",10) == 0 ){

      //-
      //- We're checking the field to see if it begins with 'Z'
      //- which indicates a concentration table.
      //-
      //- Then we check to see if we need to add the table to the
      //- A or B gate.
      //-


      //- fetch the forward gate
      struct PidinStack *ppistA = PidinStackDuplicate(ppistWorking);


      //- we must look up the concentration gate
      PidinStackPushString(ppistA,"HH_concentration");
  

      struct symtab_HSolveListElement *phsleA = 
	PidinStackPushStringAndLookup(ppistA,"A");
    
      PidinStackFree(ppistA);

      if(!phsleA){
        fprintf(stdout,
      	  "Could not find forward gate kinetic for %s\n",
       	  pcPathname);
        return 0;
      }

      setParameter(phsleA,&pcField[5],value,SETPARA_NUM);

      return 1;


    }
    else if( strncmp(pcField,"Z_B->table",10) == 0 ){


	struct PidinStack *ppistB = PidinStackDuplicate(ppistWorking);


       
	PidinStackPushString(ppistB,"HH_concentration");
  

	struct symtab_HSolveListElement *phsleB = 
	  PidinStackPushStringAndLookup(ppistB,"B");
    
	PidinStackFree(ppistB);

	if(!phsleB){
	  fprintf(stdout,
		  "Could not find forward gate kinetic for %s\n",
		  pcPathname);
	  return 0;
	}

	setParameter(phsleB,&pcField[5],value,SETPARA_NUM);


	return 1;


    }
    else if( strncmp(pcField,"X_B->table",10) == 0 ){


	struct PidinStack *ppistB = PidinStackDuplicate(ppistWorking);


	
	PidinStackPushString(ppistB,"HH_activation");
  

	struct symtab_HSolveListElement *phsleB = 
	  PidinStackPushStringAndLookup(ppistB,"B");
    
	PidinStackFree(ppistB);

	if(!phsleB){
	  fprintf(stdout,
		  "Could not find backward gate kinetic for %s\n",
		  pcPathname);
	  return 0;
	}

	setParameter(phsleB,&pcField[5],value,SETPARA_NUM);


	return 1;


    }
    else if( strncmp(pcField,"X_A->table",10) == 0 ){



      
	struct PidinStack *ppistA = PidinStackDuplicate(ppistWorking);


	
	PidinStackPushString(ppistA,"HH_activation");
  

	struct symtab_HSolveListElement *phsleA = 
	  PidinStackPushStringAndLookup(ppistA,"A");
    
	PidinStackFree(ppistA);

	if(!phsleA){
	  fprintf(stdout,
		  "Could not find forward gate kinetic for %s\n",
		  pcPathname);
	  return 0;
	}

	setParameter(phsleA,&pcField[5],value,SETPARA_NUM);


	return 1;

    }

    else if( strncmp(pcField,"Y_B->table",10) == 0 ){



      
	struct PidinStack *ppistB = PidinStackDuplicate(ppistWorking);


	
	PidinStackPushString(ppistB,"HH_inactivation");
  

	struct symtab_HSolveListElement *phsleB = 
	  PidinStackPushStringAndLookup(ppistB,"B");
    
	PidinStackFree(ppistB);

	if(!phsleB){
	  fprintf(stdout,
		  "Could not find backward gate kinetic for %s\n",
		  pcPathname);
	  return 0;
	}

	setParameter(phsleB,&pcField[5],value,SETPARA_NUM);


	return 1;


    }
    else if( strncmp(pcField,"Y_A->table",10) == 0 ){



      
	struct PidinStack *ppistA = PidinStackDuplicate(ppistWorking);


	
	PidinStackPushString(ppistA,"HH_inactivation");
  

	struct symtab_HSolveListElement *phsleA = 
	  PidinStackPushStringAndLookup(ppistA,"A");
    
	PidinStackFree(ppistA);

	if(!phsleA){
	  fprintf(stdout,
		  "Could not find forward gate kinetic for %s\n",
		  pcPathname);
	  return 0;
	}

	setParameter(phsleA,&pcField[5],value,SETPARA_NUM);


	return 1;

    }



    else if(!strcmp(pcField,"X_init"))
    {


     //- Return is it's just zero, not sure if this is right
      double dNumber = strtod(value,NULL);

      if(dNumber == 0.0)
	return 1;

      //
      // A bit dangerous since I'm not making sure that HH_activation
      // has been created first. Will safty check it later.
      //
      struct PidinStack *ppistCopy = PidinStackDuplicate(ppistWorking);

      struct symtab_HSolveListElement *phsleGate = 
	PidinStackPushStringAndLookup(ppistCopy,"HH_activation");
   
      PidinStackFree(ppistCopy);


      if(!phsleGate)
	return 0;

      return setParameter(phsleGate,"state_init",value,SETPARA_GENESIS2);

    }
    else if(!strcmp(pcField,"Y_init"))
    {


     //- Return is it's just zero, not sure if this is right
      double dNumber = strtod(value,NULL);

      if(dNumber == 0.0)
	return 1;

      //
      // A bit dangerous since I'm not making sure that HH_activation
      // has been created first. Will safty check it later.
      //
      struct PidinStack *ppistCopy = PidinStackDuplicate(ppistWorking);

      struct symtab_HSolveListElement *phsleGate = 
	PidinStackPushStringAndLookup(ppistCopy,"HH_inactivation");
   
      PidinStackFree(ppistCopy);


      if(!phsleGate)
	return 0;

      return setParameter(phsleGate,"state_init",value,SETPARA_GENESIS2);

    }
    else if(!strcmp(pcField,"Z_init"))
    {


     //- Return is it's just zero, not sure if this is right
      double dNumber = strtod(value,NULL);

      if(dNumber == 0.0)
	return 1;

      //
      // A bit dangerous since I'm not making sure that HH_activation
      // has been created first. Will safty check it later.
      //
      struct PidinStack *ppistCopy = PidinStackDuplicate(ppistWorking);

      struct symtab_HSolveListElement *phsleGate = 
	PidinStackPushStringAndLookup(ppistCopy,"HH_concentration");
   
      PidinStackFree(ppistCopy);


      if(!phsleGate)
	return 0;

      return setParameter(phsleGate,"state_init",value,SETPARA_GENESIS2);

    }


  }

  return setParameter(phsleWorking,pcField,value,SETPARA_GENESIS2);

}





