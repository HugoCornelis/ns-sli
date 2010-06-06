

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

	 

	break;
      }



    case CHECK:
      {
	break;
      }





    case PROCESS:
    {
    
      //ActivationStep();
      if(simulation_time > 0){
	
	iResult = PulseGenSingleStep(pulsegen_type->ppg, 
					    simulation_time);

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


