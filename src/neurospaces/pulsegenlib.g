//genesis

/*********************************************************************

** ascfile related functionality

********************************************************************/
addaction FINISH 30111


/*************************************************************************

** global variables

*************************************************************************/

//==========================================================================
//	name		data		function		class	
//==========================================================================

					
object	 pulsegen  pulsegen_type  PulseGenActor	genesis3 \
	-author 	"M.Nelson Caltech with changes by Mando Rodriguez" 	\
	-actions	PROCESS RESET CHECK CREATE FINISH \
	-fields         "level1 width1 delay1" \
	                "level2 width2 delay2" \
			"baselevel" \
			"trig_mode: run(0), trig(1), gate(2)" \
			"output" \ 
	-description	"Pulsegen replacement that integrates with neurospaces"


