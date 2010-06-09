

//------------------------------------------------------------
/*!
 *   \file nsintegratoractor.c
 *   \author Mando Rodriguez

 */
//-------------------------------------------------------------
#include "nsintegrator.h"
#include "pulsegen_g@.h"
#include "heccer/pulsegen.h"

extern double simulation_time;



//-------------------------------------------------------------
/*
 *r
 */
//-------------------------------------------------------------
int PulseGenActor(struct pulsegen_type *pulsegen_type,
			       Action *action){

  


  struct pulsegen_type *ppgt = pulsegen_type;
  
  //- set default result : ok
  int iResult = 1;

  //- select action

  SELECT_ACTION(action)
  {
      
    //- create



     case CREATE:
     {

       //- Making certain this is NULL and not garbage.

       pulsegen_type->pdOutput = NULL;
       
       break;
     }



    case CHECK:
      {
	break;
      }





    case PROCESS:
    {
    
      //- Here i check to see if the output pointer to the model
      //- containers value in the genesis2 pulsegen is set. If 
      //- not then I retrieve the value from the model container
      //- and set it to the pointer in my native genesis 2 object.
      //- This allows them to have their data synced.

      if(!pulsegen_type->pdOutput)
      {
	
	struct PidinStack *ppist = PidinStackParse(pulsegen_type->name);

	PidinStackUpdateCaches(ppist);

	struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist);


	struct symtab_Parameters *ppar = SymbolFindParameter(phsle, ppist, "output");

	pulsegen_type->pdOutput = &(ppar->uValue.dNumber);

      }

      if(simulation_time > 0){
	
	iResult = PulseGenSingleStep(pulsegen_type->ppg, 
					    simulation_time);

	if(pulsegen_type->pdOutput)
	{
	  (*(pulsegen_type->pdOutput)) = pulsegen_type->output;
	}

	//	fprintf(stdout,"%0.9g\n",pulsegen_type->output);

      }

      break;
    }


    case RESET:
    {


      iResult = NSPulseGenReset(pulsegen_type);

      break;
    }


    case FINISH:
    {

      iResult = PulseGenFinish(pulsegen_type->ppg);

      break;

    }



    }

    //- return result

    return(iResult);
}


