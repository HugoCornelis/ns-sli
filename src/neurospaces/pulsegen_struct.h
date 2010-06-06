
#ifndef PULSEGEN_STRUCT_H
#define PULSEGEN_STRUCT_H


#include "struct_defs.h"


struct pulsegen_type {

  ELEMENT_TYPE

  double output;

  double level1;

  double width1;

  double delay1;

  double level2;

  double width2;

  double delay2;

  double baselevel;

  double trig_time;

  int trig_mode;

  int previous_input;

  struct simobj_PulseGen *ppg;
 
};


#endif
