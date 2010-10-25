shelldir = $(top_builddir)/src/shell
simdir = $(top_builddir)/src/sim
scriptdir = $(top_builddir)/src/script
utildir = $(top_builddir)/src/util
olfdir = $(top_builddir)/src/olf

c2genesisdir = $(top_builddir)/src/c2genesis
c2genesis = $(c2genesisdir)/c2genesis
makestructs = $(c2genesisdir)/makestructs
makelib = $(c2genesisdir)/makelib

# \todo these variables are relative to builddir, should be relative to srcdir

INCLUDES = -I$(utildir) -I$(shelldir) -I$(simdir) -I$(scriptdir) -I$(olfdir) -I/usr/local/neurospaces/instrumentor -I/usr/local/heccer

AM_CPPFLAGS = -DPRE_PROTO_TRAVERSAL

pkginclude_LIBRARIES = libneurospaces.a

EXTRA_DIST = \
	ascfilelib.g \
	hsolvelib.g \
	neurospaceslib.g \
	nsintegratorlib.g \
	pulsegenlib.g

BUILT_SOURCES = \
	ascfile_d@.c \
	ascfile_g@.c \
	ascfile_g@.h \
	ascfile_l@.c \
	hsolve_d@.c \
	hsolve_g@.c \
	hsolve_g@.h \
	hsolve_l@.c \
	neurospaces_d@.c \
	neurospaces_g@.c \
	neurospaces_g@.h \
	neurospaces_l@.c \
	nsintegrator_d@.c \
	nsintegrator_g@.c \
	nsintegrator_g@.h \
	nsintegrator_l@.c \
	pulsegen_d@.c \
	pulsegen_g@.c \
	pulsegen_g@.h \
	pulsegen_l@.c

CLEANFILES = \
	ascfile_d@.c \
	ascfile_g@.c \
	ascfile_g@.h \
	ascfile_l@.c \
	hsolve_d@.c \
	hsolve_g@.c \
	hsolve_g@.h \
	hsolve_l@.c \
	neurospaces_d@.c \
	neurospaces_g@.c \
	neurospaces_g@.h \
	neurospaces_l@.c \
	nsintegrator_d@.c \
	nsintegrator_g@.c \
	nsintegrator_g@.h \
	nsintegrator_l@.c \
	pulsegen_d@.c \
	pulsegen_g@.c \
	pulsegen_g@.h \
	pulsegen_l@.c \
	tmp_ascfile_struct.h \
	tmp_hsolve_struct.h \
	tmp_neurospaces_struct.h \
	tmp_nsintegrator_struct.h \
	tmp_pulsegen_struct.h


ascfile_d@.c:
	$(CPP) ascfile_struct.h -I../script -I../util -I../sim -I../shell -I/usr/local/neurospaces/instrumentor -I/usr/local/heccer -DPRE_PROTO_TRAVERSAL > tmp_ascfile_struct.h
	$(makestructs) tmp_ascfile_struct.h ascfile -I nsintegrator.h -NI -o ascfile_d@.c

ascfile_g@.c:
	$(c2genesis) ascfilelib.g nsintegrator.h ascfile

ascfile_l@.c:
	$(makelib) ascfile -o ascfile_l@.c


hsolve_d@.c:
	$(CPP) hsolve_struct.h -I../script -I../util -I../sim -I../shell -I/usr/local/neurospaces/instrumentor -I/usr/local/heccer -DPRE_PROTO_TRAVERSAL > tmp_hsolve_struct.h
	$(makestructs) tmp_hsolve_struct.h hsolve -I nsintegrator.h -NI -o hsolve_d@.c

hsolve_g@.c:
	$(c2genesis) hsolvelib.g nsintegrator.h hsolve

hsolve_l@.c:
	$(makelib) hsolve -o hsolve_l@.c


neurospaces_d@.c:
	$(CPP) neurospaces_struct.h -I../script -I../util -I../sim -I../shell > tmp_neurospaces_struct.h
	$(makestructs) tmp_neurospaces_struct.h neurospaces -I neurospaces_ext.h -NI -o neurospaces_d@.c

neurospaces_g@.c:
	$(c2genesis) neurospaceslib.g neurospaces_ext.h neurospaces

neurospaces_g@.h: 
	$(c2genesis) neurospaceslib.g neurospaces_ext.h neurospaces

neurospaces_l@.c:
	$(makelib) neurospaces -o neurospaces_l@.c


nsintegrator_d@.c:
	$(CPP) nsintegrator_struct.h -I../script -I../util -I../sim -I../shell -I/usr/local/neurospaces/instrumentor -DPRE_PROTO_TRAVERSAL > tmp_nsintegrator_struct.h
	$(makestructs) tmp_nsintegrator_struct.h nsintegrator -I nsintegrator.h -NI -o nsintegrator_d@.c


nsintegrator_g@.c:
	$(c2genesis) nsintegratorlib.g nsintegrator.h nsintegrator

nsintegrator_g@.h: 
	$(c2genesis) nsintegratorlib.g nsintegrator.h nsintegrator

nsintegrator_l@.c:
	$(makelib) nsintegrator -o nsintegrator_l@.c


pulsegen_d@.c:
	$(CPP) pulsegen_struct.h -I../script -I../util -I../sim -I../shell -I/usr/local/neurospaces/instrumentor -I/usr/local/heccer -DPRE_PROTO_TRAVERSAL > tmp_pulsegen_struct.h
	$(makestructs) tmp_pulsegen_struct.h pulsegen -I nsintegrator.h -NI -o pulsegen_d@.c

pulsegen_g@.c:
	$(c2genesis) pulsegenlib.g nsintegrator.h pulsegen

pulsegen_l@.c:
	$(makelib) pulsegen -o pulsegen_l@.c





pkginclude_HEADERS = \
	ascfile_struct.h \
	hsolve_struct.h \
	neurospaces_defs.h \
	neurospaces_ext.h  \
	neurospaces_struct.h \
	neurospacesquery.h \
	neurospacessetup.h \
	neurospacessupport.h \
	nsintegrator.h \
	nsintegrator_struct.h \
	pulsegen_struct.h


libneurospaces_a_SOURCES = \
	ascfile_d@.c \
	ascfile_g@.c \
	ascfile_g@.h \
	ascfile_l@.c \
	ascfileactor.c \
	connect.c \
	filters.c \
	hsolve_d@.c \
	hsolve_g@.c \
	hsolve_g@.h \
	hsolve_l@.c \
	hsolveactor.c \
	neurospaces_d@.c \
	neurospaces_g@.c \
	neurospaces_l@.c \
	neurospacesmodel.c \
	neurospacesquery.c \
	new_parser.c \
	nsasc.c \
	nscall.c \
	nscomm.c \
	nscopy.c \
	nscreate.c \
	nsgetfield.c \
	nsintegrator.c \
	nsintegrator_d@.c \
	nsintegrator_g@.c \
	nsintegrator_l@.c \
	nsintegratoractor.c \
	nsintegratorverbose.c \
	nslistcommands.c \
	nsmove.c \
	nsmsg.c \
	nspulsegen.c \
	nsreset.c \
	nssetelement.c \
	nssetfield.c \
	nssetup.c \
	nsshowfield.c \
	nstabcreate.c \
	nstabfill.c \
	nstweak.c \
	pulsegen_d@.c \
	pulsegen_g@.c \
	pulsegen_g@.h \
	pulsegen_l@.c \
	pulsegenactor.c \
	solvercreate.c 


libneurospaces_a_DEPENDENCIES = \
	ascfile_d@.c \
	ascfile_g@.c \
	ascfile_g@.h \
	ascfile_l@.c \
	hsolve_d@.c \
	hsolve_g@.c \
	hsolve_g@.h \
	hsolve_l@.c \
	neurospaces_d@.c \
	neurospaces_g@.c \
	neurospaces_g@.h \
	neurospaces_l@.c \
	nsintegrator_d@.c \
	nsintegrator_g@.c \
	nsintegrator_g@.h \
	nsintegrator_l@.c \
	pulsegen_d@.c \
	pulsegen_g@.c \
	pulsegen_g@.h \
	pulsegen_l@.c

dist-hook: $(libneurospaces_a_DEPENDENCIES)

