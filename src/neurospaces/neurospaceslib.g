//genesis

/*********************************************************************

** neurospaces related functionality

********************************************************************/


addaction	NEUROSPACES_READ	20001
addaction	NEUROSPACES_QUERY	20002
addaction	NEUROSPACES_SETUP	20003


// addfunc neurospaces neurospaces_read_model int
// addfunc solverfield solver_field_info char*
// addfunc solverelement solver_element_info char*


/*
*************************************************************************
**                         NeuroSpaces objects                         **
*************************************************************************
*/
//==========================================================================
//	name		data		function		class	
//==========================================================================


object	neurospaces	neurospaces_type  NeuroSpacesActor	device	\
	-author 	"Hugo Cornelis" 				\
	-actions	CREATE RESET NEUROSPACES_READ NEUROSPACES_QUERY	\
		NEUROSPACES_SETUP					\
	-description	"Neurospaces interface"
