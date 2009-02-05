//------------------------------------------------------------
/*!
 *   \file nsintegratoractor.c
 *   \author Mando Rodriguez

 */
//-------------------------------------------------------------
#include "nsintegrator.h"
#include "ascfile_g@.h"




//-------------------------------------------------------------
/*
 *
 */
//-------------------------------------------------------------
int AscFileActor(struct ascfile_type *pascfile_type,
			       Action *action){

  

  int i;

  
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


	printf(stdout,"OMGWTFBBQ!!1one!!!\n");
	break;
      }


    case RESET:
      {


	break;
      }




    }

    //- return result

    return(iResult);
}


