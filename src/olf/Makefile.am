shelldir = $(top_srcdir)/src/shell
simdir = $(top_srcdir)/src/sim
scriptdir = $(top_srcdir)/src/script
utildir = $(top_srcdir)/src/util

c2genesisdir = $(top_srcdir)/src/c2genesis
c2genesis = $(c2genesisdir)/c2genesis
makestructs = $(c2genesisdir)/makestructs
makelib = $(c2genesisdir)/makelib


INCLUDES = -I$(utildir) -I$(shelldir) -I$(simdir) -I$(scriptdir) -I/usr/local/neurospaces/instrumentor 

AM_CPPFLAGS = -DPRE_PROTO_TRAVERSAL

noinst_LIBRARIES = libolf.a

BUILT_SOURCES = \
	olf_d@.c \
	olf_g@.c \
	olf_g@.h \
	olf_l@.c 

CLEANFILES = \
	olf_d@.c \
	olf_g@.c \
	olf_g@.h \
	olf_l@.c \
	tmp_olf_struct.h 


olf_d@.c: olflib.g
	cpp -P olf_struct.h tmp_olf_struct.h -I../script -I../util -I../sim -I../shell
	$(makestructs) tmp_olf_struct.h olf -I ./olf_ext.h -NI -o olf_d@.c

olf_g@.c: olflib.g
	$(c2genesis) olflib.g olf_ext.h olf

olf_l@.c: olflib.g
	$(makelib) olf -o olf_l@.c


noinst_HEADERS = \
	olf_defs.h \
	olf_ext.h \
	olf_struct.h


libolf_a_SOURCES = \
	dd_syn.c \
	disk_in.c \
	interp2d.c \
	new_interp.c \
	receptor2.c \
	receptor.c \
	tab2channel.c \
	tabchannel.c \
	tabcurrent.c \
	tabfiles.c \
	tabgate.c \
	table2d.c \
	table.c \
	olf_d@.c \
	olf_g@.c \
	olf_l@.c 

