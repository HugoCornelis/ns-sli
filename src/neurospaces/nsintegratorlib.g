//genesis

/*********************************************************************

** neurospaces related functionality

********************************************************************/
addaction	 NSINTEGRATOR_DUMP	20101



/*************************************************************************

** global variables

*************************************************************************/

int HECCER_DUMP_SERVICE = {2 ** 7}
int HECCER_DUMP_INDEXERS_SUMMARY				= {2 ** 8}
int HECCER_DUMP_INDEXERS_STRUCTURE				= {2 ** 9}
int HECCER_DUMP_INTERMEDIARY_COMPARTMENTS_PARAMETERS	= {2 ** 1}
int HECCER_DUMP_INTERMEDIARY_COMPARTMENT_SUMMARY		= {2 ** 2}
int HECCER_DUMP_INTERMEDIARY_MECHANISM_SUMMARY		= {2 ** 3}
int HECCER_DUMP_INTERMEDIARY_STRUCTURE			= {2 ** 4}
int HECCER_DUMP_INTERMEDIARY_SUMMARY			= {2 ** 5}
int HECCER_DUMP_TABLE_GATE_SUMMARY				= {2 ** 12}
int HECCER_DUMP_TABLE_GATE_TABLES				= {2 ** 13}
int HECCER_DUMP_VM_COMPARTMENT_MATRIX			= {2 ** 16}
int HECCER_DUMP_VM_COMPARTMENT_DATA				= {2 ** 17}
int HECCER_DUMP_VM_COMPARTMENT_OPERATIONS			= {2 ** 18}
int HECCER_DUMP_VM_MECHANISM_DATA				= {2 ** 19}
int HECCER_DUMP_VM_MECHANISM_OPERATIONS			= {2 ** 20}
int HECCER_DUMP_VM_CHANNEL_POOL_FLUXES			= {2 ** 21}
int HECCER_DUMP_VM_SUMMARY					= {2 ** 22}
int HECCER_DUMP_VM_AGGREGATORS				= {2 ** 25}



int HECCER_DUMP_ALL =  {{HECCER_DUMP_INDEXERS_SUMMARY} + \			
			{HECCER_DUMP_INDEXERS_STRUCTURE} + \
			{HECCER_DUMP_INTERMEDIARY_COMPARTMENTS_PARAMETERS} + \
			{HECCER_DUMP_INTERMEDIARY_COMPARTMENT_SUMMARY} + \		
			{HECCER_DUMP_INTERMEDIARY_MECHANISM_SUMMARY} + \
			{HECCER_DUMP_INTERMEDIARY_STRUCTURE} + \	
			{HECCER_DUMP_INTERMEDIARY_SUMMARY} + \
			{HECCER_DUMP_TABLE_GATE_SUMMARY} + \
			{HECCER_DUMP_TABLE_GATE_TABLES} + \
			{HECCER_DUMP_VM_COMPARTMENT_MATRIX} + \
			{HECCER_DUMP_VM_COMPARTMENT_DATA} + \
			{HECCER_DUMP_VM_COMPARTMENT_OPERATIONS} + \
			{HECCER_DUMP_VM_MECHANISM_DATA} + \
			{HECCER_DUMP_VM_MECHANISM_OPERATIONS} + \
			{HECCER_DUMP_VM_CHANNEL_POOL_FLUXES} + \
			{HECCER_DUMP_VM_SUMMARY} + \
			{HECCER_DUMP_VM_AGGREGATORS}}	


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


