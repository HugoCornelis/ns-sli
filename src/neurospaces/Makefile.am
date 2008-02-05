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

noinst_LIBRARIES = libneurospaces.a

BUILT_SOURCES = \
	neurospaces_d@.c \
	neurospaces_g@.c \
	neurospaces_g@.h \
	neurospaces_l@.c

CLEANFILES = \
	neurospaces_d@.c \
	neurospaces_g@.c \
	neurospaces_g@.h \
	neurospaces_l@.c \
	tmp_neurospaces_struct.h

neurospaces_d@.c:
	cpp -P neurospaces_struct.h tmp_neurospaces_struct.h -I../script -I../util -I../sim -I../shell
	$(makestructs) tmp_neurospaces_struct.h neurospaces -I neurospaces_ext.h -NI -o neurospaces_d@.c

neurospaces_g@.c:
	$(c2genesis) neurospaceslib.g neurospaces_ext.h neurospaces
 
neurospaces_l@.c:
	$(makelib) neurospaces -o neurospaces_l@.c


libneurospaces_a_SOURCES = \
	neurospacesmodel.c \
	neurospacesquery.c \
	neurospacesfield.c \
	neurospaces_d@.c \
	neurospaces_g@.c \
	neurospaces_l@.c
