shelldir = $(top_srcdir)/src/shell
scriptdir = $(top_srcdir)/src/script
utildir = $(top_srcdir)/src/util
pardir = $(top_srcdir)/src/par
nsdir = $(top_srcdir)/src/neurospaces
hierarchy = /usr/local/neurospaces/instrumentor

c2genesisdir = $(top_srcdir)/src/c2genesis
c2genesis = $(c2genesisdir)/c2genesis
makestructs = $(c2genesisdir)/makestructs
makefunc = $(c2genesisdir)/makefunc


INCLUDES = \
	-I$(utildir) \
	-I$(shelldir) \
	-I$(scriptdir) \
	-I$(pardir) \
	-I$(top_srcdir) \
	-I$(nsdir)	\
	-I$(hierarchy)

BUILT_SOURCES = \
	basic_d@.c \
	basic_f@.c \
	basic_g@.c 

CLEANFILES = \
	basic_d@.c \
	basic_f@.c \
	basic_g@.c \
	tmp_sim_struct.h


noinst_LIBRARIES = libsim.a

basic_d@.c:
	cpp -P -I$(scriptdir) -I$(shelldir) -I$(pardir) sim_struct.h > tmp_sim_struct.h
	$(makestructs) tmp_sim_struct.h basic -I sim_ext.h -NI -o basic_d@.c
	rm tmp_sim_struct.h

basic_g@.c:
	$(c2genesis) simlib.g sim_ext.h basic
 
basic_f@.c:
	$(makefunc) simfuncs basic > basic_f@.c

AM_CFLAGS = -DPRE_PROTO_TRAVERSAL

libsim_a_SOURCES= \
		sim_access.c \
		sim_action.c \
		sim_address.c \
		sim_attach.c \
		sim_base.c \
		sim_bindings.c \
		sim_buffer.c \
		sim_call.c \
		sim_check.c \
		sim_class.c \
		sim_clock.c \
		sim_copy.c \
		sim_create.c \
		sim_current.c \
		sim_delete.c \
		sim_detach.c \
		sim_dump.c \
		sim_element.c \
		sim_elemlist.c \
		sim_estack.c \
		sim_event.c \
		sim_extfields.c \
		sim_extobject.c \
		sim_fieldlist.c \
		sim_fields.c \
		sim_file.c \
		sim_find.c \
		sim_get.c \
		sim_hash.c \
		sim_help.c \
		sim_index.c \
		sim_intgrt.c \
		sim_item.c \
		sim_list.c \
		sim_main.c \
		sim_malloc.c \
		sim_markers.c \
		sim_mask.c \
		sim_map.c \
		sim_method.c \
		sim_move.c \
		sim_msg.c \
		sim_name.c \
		sim_notes.c \
		sim_object.c \
		sim_ops.c \
		sim_position.c \
		sim_random.c \
		sim_reset.c \
		sim_response.c \
		sim_save.c \
		sim_sched.c \
		sim_set.c \
		sim_simulate.c \
		sim_stack.c \
		sim_status.c \
		sim_show.c \
		sim_step.c \
		sim_strings.c \
		sim_tform.c \
		sim_tree.c \
		sim_tstack.c \
		sim_valid.c \
		sim_value.c \
		sim_quit.c \
		nsim_wildcard.c \
	basic_d@.c \
	basic_f@.c \
	basic_g@.c



