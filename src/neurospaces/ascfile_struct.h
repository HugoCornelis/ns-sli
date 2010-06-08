
#ifndef ASCFILE_STRUCT_H
#define ASCFILE_STRUCT_H


#include "struct_defs.h"


struct ascfile_type {


  ELEMENT_TYPE

  int append; 

  char *filename;

  int flush;

  int initialize;

  int is_open;

  int leave_open;

  char *float_format;
  
  struct OutputGenerator *pog;

};


#endif
