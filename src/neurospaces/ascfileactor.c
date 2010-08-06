

//------------------------------------------------------------
/*!
 *   \file nsintegratoractor.c
 *   \author Mando Rodriguez

 */
//-------------------------------------------------------------
#include "nsintegrator.h"
#include "ascfile_g@.h"
#include "heccer/output.h"

extern double simulation_time;



//-------------------------------------------------------------
/*
 *r
 */
//-------------------------------------------------------------
int AscFileActor(struct ascfile_type *pascfile_type,
			       Action *action){

  


  struct ascfile_type *pasc = pascfile_type;
  
  struct OutputGenerator *pog = NULL;

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

	//-
	//- This variable assignment was added to remove an annoying memory alignment
	//- bug in Mac OSX.
	if(!pog)
	{
	  pog = pascfile_type->pog;
	}

	iResult = OutputGeneratorTimedStep(pog, 
					    simulation_time);
	if(pascfile_type->flush)
	   OutputGeneratorFlush(pog);

      }

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


