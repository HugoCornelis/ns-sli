#include "nsintegrator.h"

#include <stdlib.h>	/* malloc */
#include "shell_ext.h"

void NSListCommands()
{

  char **ppcCommands = GetFuncNames();


  int i = 0;
  fprintf(stdout,"---\n");
  while(ppcCommands[i])
  {

    fprintf(stdout,"  - %s\n",ppcCommands[i]);
    i++;

  }

  free(ppcCommands);

}
