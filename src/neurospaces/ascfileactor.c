

//------------------------------------------------------------
/*!
 *   \file nsintegratoractor.c
 *   \author Mando Rodriguez

 */
//-------------------------------------------------------------
#include "nsintegrator.h"
#include "ascfile_g@.h"


extern double simulation_time;



//-------------------------------------------------------------
/*
 *r
 */
//-------------------------------------------------------------
int AscFileActor(struct ascfile_type *pascfile_type,
			       Action *action){

  


  struct ascfile_type *pasc = pascfile_type;
  
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
	
      iResult = OutputGeneratorTimedStep(pascfile_type->pog, 
					     simulation_time);
      break;
    }


    case RESET:
    {


      iResult = AscReset(pascfile_type);

      break;
    }


    case FINISH:
    {

      iResult = OutputGeneratorFinish(pascfile_type->pog);

      break;

    }



    }

    //- return result

    return(iResult);
}


