//------------------------------------------------------------------
/*!
 *  \file nscall.c
 *  \author Mando Rodriguez
 *
 *  This file contains functions for parsing out GENESIS calls made
 *  to objects that are in the model-container and have no presensce 
 *  in the element namespace.
 * 
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "shell_func_ext.h"


#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"

#include "nsintegrator.h"






//--------------------------------------------------------------------
/*!
 *  \fun int NSCall(int argc, char **argv)
 *  \param argc Number of strings contained in argv
 *  \param argv An aray of strings to be parsed into calls.
 *  \return 0 on error, 1 on success.
 *  \sa NSTabCreate
 *  \sa NSTabFill
 *
 *  Function parses out GENESIS calls and delegates them to functions
 *  for certain GENESIS features.
 *  
*/
//--------------------------------------------------------------------
int NSCall(int argc, char **argv){



  if(!strcmp(argv[2],"TABCREATE"))
  {

    if (argc < 4) {
      printf("usage : %s field xdivs xmin xmax\n","tabcreate");
      return(0);
    }



    if( NSTabCreate(argc,argv) == 0 ){

      Error();
      printf("%s : Error performing Tabcreation in model-container on '%s'.\n",
	     argv[0],argv[2]);
      return 0;
    }

    OK();
    return 1;


  }//=end TABCREATE case
  else if(!strcmp(argv[2],"TABFILL"))
  {

    if (argc != 6) 
    {
      printf("usage : %s field xdivs fill_mode\n","tabfill");
      return(0);
    }

    if(strcmp("0",argv[5]))
    {
      printf("Invalid fill_mode, must be '0'\n");
      return 0;
      
    }



    if(NSTabFill(argv[1], argv[3], argv[4]))
    {
      OK();
      return ;
    }
    else

      printf("Error filling table for %s %s\n",argv[1],argv[3]);
      return 0;

  }




}






//-------------------------------------------------------------
/*!
 *  \fun int nsCallCheck(char *pcCall)
 *  \param A string with the argument for the call parameter.
 *  \sa NSCall
 *
 *  Function is simply a check to see if the sli has parsed out 
 *  a parameter for a tabulated operation.
 */
//--------------------------------------------------------------
int nsCallCheck(char *pcCall){
  
  char *NeurospacesCalls[] = {
    "TABCREATE",
    "TABFILL",
    NULL,
  };


  int i;
  for(i=0;NeurospacesCalls[i] != NULL; i++){

    if(!strcmp(pcCall,NeurospacesCalls[i]))
      return 1;

  }

  return 0;

}
