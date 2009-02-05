
#ifndef ASCFILE_STRUCT_H
#define ASCFILE_STRUCT_H


#include "struct_defs.h"


struct ascfile_type {


  ELEMENT_TYPE

  char *filename;

  int append; 

  int flush;

  int leave_open;

  struct OutputGenerator *og;

};


#endif
