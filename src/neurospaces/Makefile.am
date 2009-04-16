shelldir = $(top_srcdir)/src/shell
simdir = $(top_srcdir)/src/sim
scriptdir = $(top_srcdir)/src/script
utildir = $(top_srcdir)/src/util
olfdir = $(top_srcdir)/src/olf

c2genesisdir = $(top_srcdir)/src/c2genesis
c2genesis = $(c2genesisdir)/c2genesis
makestructs = $(c2genesisdir)/makestructs
makelib = $(c2genesisdir)/makelib


INCLUDES = -I$(utildir) -I$(shelldir) -I$(simdir) -I$(scriptdir) -I$(olfdir) -I${prefix}/neurospaces/instrumentor 

AM_CPPFLAGS = -DPRE_PROTO_TRAVERSAL

noinst_LIBRARIES = libneurospaces.a

BUILT_SOURCES = \
	neurospaces_d@.c \
	neurospaces_g@.c \
	neurospaces_g@.h \
	neurospaces_l@.c \
	nsintegrator_d@.c \
	nsintegrator_g@.c \
	nsintegrator_g@.h \
	nsintegrator_l@.c \
	ascfile_d@.c \
	ascfile_g@.c \
	ascfile_g@.h \
	ascfile_l@.c 

CLEANFILES = \
	neurospaces_d@.c \
	neurospaces_g@.c \
	neurospaces_g@.h \
	neurospaces_l@.c \
	tmp_neurospaces_struct.h \
	nsintegrator_d@.c \
	nsintegrator_g@.c \
	nsintegrator_g@.h \
	nsintegrator_l@.c \
	tmp_nsintegrator_struct.h \
	ascfile_d@.c \
	ascfile_g@.c \
	ascfile_g@.h \
	ascfile_l@.c \
	tmp_ascfile_struct.h 



ascfile_d@.c:
	$(CPP) ascfile_struct.h -I../script -I../util -I../sim -I../shell -I/usr/local/heccer -DPRE_PROTO_TRAVERSAL > tmp_ascfile_struct.h
	$(makestructs) tmp_ascfile_struct.h ascfile -I nsintegrator.h -NI -o ascfile_d@.c


ascfile_g@.c:
	$(c2genesis) ascfilelib.g nsintegrator.h ascfile

ascfile_l@.c:
	$(makelib) ascfile -o ascfile_l@.c


neurospaces_d@.c:
	$(CPP) neurospaces_struct.h -I../script -I../util -I../sim -I../shell > tmp_neurospaces_struct.h
	$(makestructs) tmp_neurospaces_struct.h neurospaces -I neurospaces_ext.h -NI -o neurospaces_d@.c

neurospaces_g@.c:
	$(c2genesis) neurospaceslib.g neurospaces_ext.h neurospaces

neurospaces_l@.c:
	$(makelib) neurospaces -o neurospaces_l@.c



nsintegrator_d@.c:
	$(CPP) nsintegrator_struct.h -I../script -I../util -I../sim -I../shell -I/usr/local/neurospaces/instrumentor -DPRE_PROTO_TRAVERSAL > tmp_nsintegrator_struct.h
	$(makestructs) tmp_nsintegrator_struct.h nsintegrator -I nsintegrator.h -NI -o nsintegrator_d@.c


nsintegrator_g@.c:
	$(c2genesis) nsintegratorlib.g nsintegrator.h nsintegrator

nsintegrator_l@.c:
	$(makelib) nsintegrator -o nsintegrator_l@.c







noinst_HEADERS = \
	neurospaces_defs.h \
	neurospaces_ext.h  \
	neurospacesquery.h \
	neurospacessetup.h \
	neurospaces_struct.h \
	neurospacessupport.h \
	nsintegrator.h \
	nsintegrator_struct.h \
	ascfile_struct.h 


libneurospaces_a_SOURCES = \
	neurospacesmodel.c \
	neurospacesquery.c \
	neurospacesfield.c \
	nsintegrator.c \
	nssetelement.c \
	nssetfield.c \
	nscreate.c \
	nscopy.c \
	nsmsg.c \
	nscomm.c \
	nstabcreate.c \
	nscall.c \
	nssetup.c \
	nstweak.c \
	nstabfill.c \
	nsintegratorverbose.c \
	heccercreate.c \
	nsreset.c \
	nsasc.c \
	ascfileactor.c \
	new_parser.c \
	neurospaces_d@.c \
	neurospaces_g@.c \
	neurospaces_l@.c \
	nsintegrator_d@.c \
	nsintegrator_g@.c \
	nsintegrator_l@.c \
	ascfile_d@.c \
	ascfile_g@.c \
	ascfile_g@.h \
	ascfile_l@.c \
	nsintegratoractor.c

