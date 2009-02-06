

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
	//t check all heccer clocks: within limits ?
	break;
      }






      /***************************************
       *
       * performs a single step on every heccer
       * instance.
       *
       ***************************************/
    case PROCESS:
    {

      
      iResult = OutputGeneratorTimedStep(pascfile_type->og, 
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

      iResult = OutputGeneratorFinish(pascfile_type->og);

      break;

    }



    }

    //- return result

    return(iResult);
}


