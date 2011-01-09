/* SYNAPTIC CONDUCTANCE PARAMETERS */
float E_AMPA 		= 0.0		// reversal potential (volts)
float tauRise_AMPA 	= 0.003		// rise time for gsyn waveform (seconds)
float tauFall_AMPA 	= 0.003		// fall time for gsyn waveform (seconds)
float G_AMPA 		= 0.5e-9	// gmax for gsyn (siemens)

/* STDP SYNCHAN SETTINGS */
float vthresh_stdp	= -0.01		// spike discrimination threshold (volts)
float refract_stdp 	= 0.002		// a single spike is narrower than this (sec)
float minwt_stdp	= 0.2		// minimal weight a synapse can be depressed to
float maxwt_stdp	= 5.0		// maximal weight a synapse can be increased to
int   chgwts_stdp	= 1			// plasticity is on
float NArate_stdp	= 0.0		// nonassociative plasticity is off
int   hlength_stdp	= 1	// only the most recent event matters for STDP
int   Vspkmsg_stdp	= 1	// use second voltage message for spike discrim
// (= V soma)

/* PLASTICITY TABLE PARAMETERS 
 *	--the STDP function here will be rate-based. Steady-state plasticity is
 *		assumed to be maximal for any timing difference, but the rate at
 *		which the synapse will potentiate or depress is time-dependent.
 *	--Winf_pre is uniformly max_weight
 *	--Winf_post is uniformly min_weight
 *	--Wrate_pre has a linear increase from 0 to a peak at 2 milliseconds, 
 *		followed by an exponential decline from the peak with time constant
 *		TauPre_stdp. The peak rate is set by parameter maxrate_Pre_stdp.
 *	--Wrate_post has a linear increase from 0 to a peak at 2 milliseconds, 
 *		followed by an exponential decline from the peak with time constant
 *		TauPost_stdp. The peak rate is set by parameter maxrate_Post_stdp.
 */
float xmax_stdp		= 0.5	// max timediff that can cause STDP (sec)
float TauPre_stdp	= 0.015	// exponential time window for pre-post stdp
float TauPost_stdp	= 0.050	// exponential time window for post-pre stdp
float PkTimePre_stdp	= 0.002	// optimal timing for pre-post stdp (sec)
float PkTimePost_stdp	= 0.002 // optimal timing for post-pre stdp (sec)
float maxrate_Pre_stdp	= 0.012	// plasticity rate at optimal pre-post time
float maxrate_Post_stdp = 0.012	// plasticity rate at optimal post-pre time

int   stdp_type			= 0	// conventional stdp by default


/****************************** fill_stdp_tables *****************************/
/*	Allocate and fill the plasticity tables according to the parameters above
	and the stdp_type flag. */

function fill_stdp_tables(synpath, stdp_type)
	str synpath
	int stdp_type

	int i, xdivs
	float xmin, xmax, x, dx, wrate

	xdivs = 500	// actual # table entries = xdivs + 1
	xmin = 0.0
	xmax = 0.5
	dx = ({xmax} - {xmin})/{xdivs}	// 1 msec per

	call {synpath} TABCREATE {xdivs} {xmax}	// note function call is different
											//	from tabchannels
	
	// If stdp_type == 0, conventional stdp; else anti-stdp

	// Winf tables: 
	if ({stdp_type} == 0)
		for (i = 0; i <= {xdivs}; i = i+1)
			setfield {synpath} Winf_pre->table[{i}] {maxwt_stdp}
			setfield {synpath} Winf_post->table[{i}] {minwt_stdp}
		end
	else
		for (i = 0; i <= {xdivs}; i = i+1)
			setfield {synpath} Winf_pre->table[{i}] {minwt_stdp}
			setfield {synpath} Winf_post->table[{i}] {maxwt_stdp}
		end
	end

	// Wrate tables: contain the actual stdp function form. This way
	//	the rate is dependent on timing but the steady-state level is
	//	only dependent on which event happened first.
	// First, fill portion between 0 and PkTimePre...
	x = 0.0
	i = 0
	while({x} < {PkTimePre_stdp})
		wrate = {maxrate_Pre_stdp} * {x} / {PkTimePre_stdp}
		setfield {synpath} Wrate_pre->table[{i}] {wrate}
		x = {x} + {dx}
		i = {i} + 1
	end

	// Continue filling pre table, now using exponential decay function...
	x = {x} - {PkTimePre_stdp}
	if ({x} < 0)
		x = 0
	end
	while (i <= {xdivs})
		wrate = {maxrate_Pre_stdp} * {exp {((-1*{x})/{TauPre_stdp})}}
		setfield {synpath} Wrate_pre->table[{i}] {wrate}
		x = {x} + {dx}
		i = {i} + 1
	end

	// Now post-pre Rate table, starting with portion between 0 and PkTimePost
	x = 0.0
	i = 0
	while({x} < {PkTimePost_stdp})
		wrate = {maxrate_Post_stdp} * {x} / {PkTimePost_stdp}
		setfield {synpath} Wrate_post->table[{i}] {wrate}
		x = {x} + {dx}
		i = {i} + 1
	end

	// Continue filling pre table, now using exponential decay function...
	x = {x} - {PkTimePost_stdp}
	if ({x} < 0)
		x = 0
	end
	while (i <= {xdivs})
		wrate = {maxrate_Post_stdp} * {exp {((-1*{x})/{TauPost_stdp})}}
		setfield {synpath} Wrate_post->table[{i}] {wrate}
		x = {x} + {dx}
		i = {i} + 1
	end

	call {synpath} TABFILL 5000 2	// expand to 5000 pts with linear interp
	// Don't use interpolation during simulations.
	setfield {synpath} Winf_pre->calc_mode {NO_INTERP}
	setfield {synpath} Winf_post->calc_mode {NO_INTERP}
	setfield {synpath} Wrate_pre->calc_mode {NO_INTERP}
	setfield {synpath} Wrate_post->calc_mode {NO_INTERP}
end



/******************************* make_stdpAMPA *******************************/
/* Create an stdpSynchan named {name}. Set fields with default parameters.
   If the channel exists (e.g. if created by the cell reader), set the
   fields.
*/

function make_stdpAMPA(name)
	str name

	if (!({exists {name}}))
		create stdpSynchan {name}
	end
	setfield {name} 							\
		Ek 						{E_AMPA} 		\
		tau1 					{tauRise_AMPA} 	\
		tau2 					{tauFall_AMPA} 	\
		gmax 					{G_AMPA} 		\
		frequency 				0 				\
		V_thresh 				{vthresh_stdp}	\
		abs_refract 			{refract_stdp}	\
		min_weight 				{minwt_stdp} 	\
		max_weight 				{maxwt_stdp} 	\
		change_weights 			{chgwts_stdp}	\
		nonassoc_change_rate	{NArate_stdp} 	\
		event_hist_length 		{hlength_stdp} 

	fill_stdp_tables {name} {stdp_type}
end



/*************************** setup_ttab_nofile *******************************/
// FUNCTION setup_ttab_nofile(str cellpath, str synname, str comptname, float synrate, int num)

/* The original version created timetable and spikegen objects for a single
   synchan. The timetable(s) were filled internally using the rate parameter
   synrate. This simpler version uses a set of randomspike objects.
Args:
	1. cellpath: cell root path, e.g. "/cell"
	2. synname: name of the synapse being connected, such as "AMPA" or "GABA"
	3. comptname: name of compartment in which synapse is located
	4. synrate: average activity rate (Hz) for this synapse
	5. num: number of synapses to put in synchan
*/

function setup_ttab_nofile(cellpath, synname, comptname, synrate, num)
	str cellpath, synname, comptname
	float synrate
	int num

	int i

	if (! {exists {cellpath}})
		echo "Error... unknown cellpath " {cellpath}
	end

	// create a directory outside the cellpath to hold the spike
	// generators to be used.  This version uses an array of
        // randompike objects
	if (! {exists /inputs})
		create neutral /inputs
	end
	if (! {exists /inputs/{synname}})
		create neutral /inputs/{synname}
	end
	if (! {exists /inputs/{synname}/{comptname}})
		create neutral /inputs/{synname}/{comptname}
	end

	for (i=0; i<num; i=i+1)
	    // set up randomspike
	    create randomspike /inputs/{synname}/{comptname}/sgen{i}
	    setfield /inputs/{synname}/{comptname}/sgen{i} rate {synrate}
	    // spikegen informs synapse that it should activate
	    addmsg /inputs/{synname}/{comptname}/sgen{i} 	\
		{cellpath}/{comptname}/{synname} SPIKE

	end
end


// ***************************************************************************
// FUNCTION insert_synchan(str cellpath, str comptname, str synname, str libobj)

/*
	Copy an synchan named {libobj} from the library to compartment 
	{comptname}. This synapse will be named {synname}.
	To make the synapses active, you must call a separate function to 
	create timetables and connect them.

Input arguments REQUIRED: 
	1. string; cell root path (e.g. "/cell")
	2. string; name of compartment in which the synapse should be inserted.
	3. string; name to give the synapse within the compartment
		--> AMPA, GABA_A, whatever.
	4. string variable with the name of the library synapse object to be
		copied into this compartment. e.g.: "AMPA", "stdpAMPA", etc.

USAGE: 
include <this script>
str cellpath = "/cell"
str comptname = "dend1"
str synname = "AMPA_STN"
str libobj = "AMPA"
insert_synchan {cellpath} {comptname} {synname} {libobj}
*/

function insert_synchan(cellpath, comptname, synname, libobj)
	str cellpath, comptname, synname, libobj

	if (! {exists {cellpath}})
		echo "Error... unknown cellpath " {cellpath}
	end
	if (! {exists {cellpath}/{comptname}/{synname}})
		// Copy a synapse from the library to the compartment	
		copy /library/{libobj} {cellpath}/{comptname}/{synname}
		
		// Connect messages between synapse and compartment
		addmsg {cellpath}/{comptname}/{synname} \
				{cellpath}/{comptname} CHANNEL Gk Ek
		addmsg {cellpath}/{comptname} \
				{cellpath}/{comptname}/{synname} VOLTAGE Vm

		// Optional: add the somatic voltage as a second VOLTAGE message
		//	if you want to use somatic spike times for STDP
		if ({isa stdpSynchan /library/{libobj}})
			addmsg {cellpath}/soma {cellpath}/{comptname}/{synname} \
				VOLTAGE Vm
			setfield {cellpath}/{comptname}/{synname} Vspkmsg_idx \
				{Vspkmsg_stdp}
		end
	else
		echo "Skipping " {comptname} " because " {synname} " is there already."
	end
end

// ***************************************************************************
// FUNCTION add_synchans_fromfile(cellpath, synname, synname, libobj)

/*
Read a list of compartments from a file. For each compartment, check to see if 
	it already has a synapse named synname. If not, copy one from the library.
	To make these synapses active, you must call a separate function to 
	create timetables and connect them.

Input arguments REQUIRED: 
	1. string; cell root path (e.g. "/cell")
	2. string; path & name of ascii text file containing the compartment names
	3. string; name to give these synapses within the compartments
		--> AMPA, GABA_A, whatever.
	4. string variable with the name of the library synapse object to be
		copied into this compartment. e.g.: "AMPA", "stdpAMPA", etc.

USAGE: 
include <this script>
str cellpath = "/cell"
str synfname = "mySTNcompartments.txt"
str sname = "AMPA_STN"
str libobj = "AMPA"
add_synchans_fromfile {cellpath} {synfname} {sname} {libobj}
*/

function add_synchans_fromfile(cellpath, synfname, synname, libobj)
	str cellpath, synfname, synname, libobj

	if (! {exists {cellpath}})
		echo "Error... unknown cellpath " {cellpath}
	end

	// open file to list compartment names of excitatory synapses
	// File should have 1 name per line, no header info, no blank lines.
	openfile {synfname} r
	str comptname = {readfile {synfname} -linemode}

	while (! {eof {synfname}})
		if (! {exists {cellpath}/{comptname}/{synname}})
			// Copy a synapse from the library to the compartment	
			copy /library/{libobj} {cellpath}/{comptname}/{synname}
			
			// Connect messages between synapse and compartment
			addmsg {cellpath}/{comptname}/{synname}	\
					 {cellpath}/{comptname} CHANNEL Gk Ek
			addmsg {cellpath}/{comptname} \
					 {cellpath}/{comptname}/{synname} VOLTAGE Vm

			// Optional: add the somatic voltage as a second VOLTAGE message
			//	if you want to use somatic spike times for STDP
			if ({isa stdpSynchan /library/{libobj}})
				addmsg {cellpath}/soma {cellpath}/{comptname}/{synname} \
					VOLTAGE Vm
				setfield {cellpath}/{comptname}/{synname} Vspkmsg_idx \
					{Vspkmsg_stdp}
			end
		end
		comptname = {readfile {synfname} -linemode}
	end
	closefile {synfname}
end



// ***************************************************************************
// FUNCTION connect_timetables_nofile(str cellpath, str synname, float synrate)

/* 
Scan through all compartments looking for syanpses named {synname}. For each
	of those synapses, create a timetable and spikegen object and connect them
	appropriately. 

Input Arguments:
	1. cellpath: cell root path (e.g. "/cell")
	2. synname: name of synapse to search for (e.g. "AMPA")
	3. synrate: mean activation rate for each synapse (in Hz)
*/

function connect_timetables_nofile(cellpath, synname, synrate)
	str cellpath, synname
	float synrate

	str elname, comptname

	if (! {exists {cellpath}})
		echo "Error... unknown cellpath " {cellpath}
	end

	foreach elname ({el {cellpath}/##[OBJECT=compartment]})
		//echo {elname}
		if ({exists {elname}/{synname}})
			comptname = {strsub {elname} {{cellpath} @ "/"} ""}
			//echo {comptname}
			// call helper function to create timetable & spikegen
			setup_ttab_nofile {cellpath} {synname} {comptname} {synrate} {num}
		end
	end
end



// ***************************************************************************
// FUNCTION add_stdp_ev2file(str cellpath, str synname, str fnamebase)

/* 
Scan through all compartments in cellpath, find those containing an object
	named {synname} (which needs to be an stdpSynchan!), create an
	event_tofile object and connect messages to record synapse weight changes
	during a simulation.

Input Arguments:
	1. cellpath: cell root path (e.g. "/cell")
	2. synname: name of stdpSynchan synapses to look for (e.g. "stdpAMPA")
	3. fnamebase: output textfile will name will be {fnamebase} + the
		compartment name and the suffix "_ev2f.asc"
*/

function add_stdp_ev2file(cellpath, synname, fnamebase)
    str cellpath, synname
    str fnamebase
    str elname, comptname, filename
    if (! {exists {cellpath}})
        echo "Error... unknown cellpath " {cellpath}
    end
    if (! {exists /events})
       create neutral /events
    end
    if (! {exists /events/{synname}})
       create neutral /events/{synname}
    end
    foreach elname ({el {cellpath}/##[OBJECT=compartment]})
        // echo {elname}
	if ({exists {elname}/{synname}})
            // compartment contains an object of name {synname}
            // get the compt name without the preceding {cellpath}/ part.
            comptname = {strsub {elname} {{cellpath} @ "/"} ""}
            // echo {comptname}
            if (!{exists /events/{synname}/{comptname}})
               create neutral /events/{synname}/{comptname}
            end
            if ({exists /events/{synname}/{comptname}/ev2f})
              echo "Error: event_tofile already exists for " {comptname}
              quit
            else
              create event_tofile /events/{synname}/{comptname}/ev2f
              filename = {fnamebase} @ {comptname} @ "_ev2f.asc"
              setfield /events/{synname}/{comptname}/ev2f \
              threshold 0.5 fname {filename}
              addmsg {cellpath}/{comptname}/{synname} 	\
                /events/{synname}/{comptname}/ev2f INPUT WtChgFlag
              addmsg {cellpath}/{comptname}/{synname} 	\
                /events/{synname}/{comptname}/ev2f INPUT synapse[0].weight
            end
        end
    end
end

