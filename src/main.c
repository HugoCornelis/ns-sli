#ifdef sgi
#include <malloc.h>
#endif
#include <stdio.h>
#include <unistd.h>
#include <setjmp.h>
#include "sim.h"
#include "shell_func_ext.h"
#include "sim_func_ext.h"
#include "ss_func_ext.h"
#include "system_deps.h"

//x
//x removing anything having to do with the parallel 
//x functionality
//x
// #include "par_ext.h"

//t Including out Neurospaces Headers.
#include "neurospaces/nsintegrator.h"



int main(int argc, char **argv, char **envp)
{
    return(sli_main(argc, argv, envp, NULL));
}
