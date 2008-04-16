//genesis

/*********************************************************************

** neurospaces related functionality

********************************************************************/
addaction	 NSINTEGRATOR_DUMP	20101



/*************************************************************************
**                         NeuroSpaces objects                         **
*************************************************************************
*/
//==========================================================================
//	name		data		function		class	
//==========================================================================



object	 nsintegrator  nsintegrator_type  NeurospacesIntegratorActor	genesis3 \
	-author 	"Mando Rodriguez" 	\
	-actions	PROCESS RESET CHECK CREATE NSINTEGRATOR_DUMP 	\
	-description	"Neurospaces Integration"
					

addfunc		set_nsintegrator_verbose_level			do_set_nsintegrator_verbose_level		int


