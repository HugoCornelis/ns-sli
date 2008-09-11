//------------------------------------------------------------------
/*!
 *  \file nstabcreate.c
 *  \author Mando Rodriguez
 *
 *  This file contains functions for creating a tabchannel object
 *  
 * 
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

#include "neurospaces/function.h"
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"

#include "nsintegrator.h"




//-------------------------------------------------------------------
/*!
 *  \fun int isTable(char *pcName)
 *  \param pcName A string with a Name token parsed from GENESIS
 *  \return 1 if pcName is part of a table, 0 if not. 
 *
 *  
*/
//-------------------------------------------------------------------
int isTable(char *pcField){

     
  //-
  //- Check if the first character is a 'Z' which stands for
  //- concentration.

  //  if( pcField[0] != 'Z' )
  if(!strncmp(pcField,"Z_",2))
    return 0;
  else
    return 1;

}






//------------------------------------------------------------------
/*
 *  \fun int NSTabCreate(int argc, char **argv)
 *  \param argc Number of tokens in argv
 *  \param argv Array of pointers to chars
 *  \return 0 on error, 1 on success.
 */
//------------------------------------------------------------------
int NSTabCreate(int argc, char **argv){

  char *pcName = argv[1];
  char *pcField = argv[3];

  int iXdivs = atoi(argv[4]);

  double dXmin = Atod(argv[5]);
  double dXmax = Atod(argv[6]);



  struct nsintegrator_type *pelnsintegrator
    = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  struct Heccer *pheccerOptions = 
    pelnsintegrator->pnsintegrator->pheccerOptions;





  if( pheccerOptions->ho.iIntervalEntries != HECCER_INTERVAL_DEFAULT_ENTRIES )
  {


    fprintf(stdout,
	    "Warning: Tabchannel parameter xdivs has already been set to %i for %s: (%s)\n",
	    pheccerOptions->ho.iIntervalEntries, pcName,argv[4]);

  }
  else{

    pheccerOptions->ho.iIntervalEntries = iXdivs;
    pheccerOptions->ho.iSmallTableSize = iXdivs;
  }


  

  if ( !strcmp(pcField,"X") || !strcmp(pcField,"Y") ) 
  {
  
    if( pheccerOptions->ho.dIntervalStart != HECCER_INTERVAL_DEFAULT_START )
    {


      fprintf(stdout,
	      "Warning: Tabchannel parameter xmin has already been set to %f for %s: (%s)\n",
	      pheccerOptions->ho.dIntervalStart, pcName,argv[5]);


    }
    else
      pheccerOptions->ho.dIntervalStart = dXmin;
  


    if( pheccerOptions->ho.dIntervalEnd != HECCER_INTERVAL_DEFAULT_END )
    {

 
      fprintf(stdout,
	      "Warning: Tabchannel parameter xmax has already been set to %f for %s: (%s)\n",
	      pheccerOptions->ho.dIntervalEnd, pcName,argv[6]);

     
    }
    else
      pheccerOptions->ho.dIntervalEnd = dXmax;


    return 1;


  } 
  else if (strcmp(pcField,"Z") == 0) 
  {



  
    if( pheccerOptions->ho.dConcentrationGateStart != 
	HECCER_INTERVAL_CONCENTRATION_GATE_DEFAULT_START )
    {

      fprintf(stdout,
	      "Warning: Tabchannel parameter xmin has already been set to %f for %s\n",
	      pheccerOptions->ho.dConcentrationGateStart,pcName);

    }
    else
      pheccerOptions->ho.dConcentrationGateStart = dXmin;




    if( pheccerOptions->ho.dConcentrationGateEnd != 
	HECCER_INTERVAL_CONCENTRATION_GATE_DEFAULT_END )
    {


      fprintf(stdout,
	      "Warning: Tabchannel parameter xmax has already been set to %f for %s\n",
	      pheccerOptions->ho.dConcentrationGateEnd,pcName);

    }
    else
      pheccerOptions->ho.dConcentrationGateEnd = dXmax;


    return 1;

  } 
  else {

    printf("field '%s' not known\n",pcField);
    return(0);

  }

}
