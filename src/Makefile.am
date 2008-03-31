SUBDIRS = util script c2genesis shell neurospaces par sim

utildir = $(top_srcdir)/src/util
scriptdir = $(top_srcdir)/src/script
shelldir = $(top_srcdir)/src/shell
simdir = $(top_srcdir)/src/sim
pardir = $(top_srcdir)/src/par
nsdir = $(top_srcdir)/src/neurospaces


AM_CLAGS=-DPLAINTERM

BUILT_SOURCES = \
	loadlib.c \
	liblist

CLEANFILES = \
	loadlib.c \
	liblist

bin_PROGRAMS = nsgenesis


nsgenesis_SOURCES = \
	loadlib.c 



nsgenesis_LDADD = \
	$(shelldir)/shell_lib.o \
	$(simdir)/libsim.a \
	$(shelldir)/libshell.a \
	$(utildir)/libutil.a \
	$(scriptdir)/libscript.a \
	$(pardir)/libpar.a \
	$(nsdir)/libneurospaces.a \
	-L/usr/local/lib/neurospacesread -lneurospacesread \
	-L/usr/local/lib/neurospaces/algorithms/symbol -lsymbol_algorithms \
	-L/usr/local/lib/heccer -lheccer \
	-L/usr/local/lib/heccer -lhneurospaces \
	-lfl \
	-lreadline \
	-lhistory \
	-lm \
	-lncurses

liblist: Makefile
	@echo "# liblist - This file is generated automatically." > liblist
	@echo "#           DO NOT EDIT.  Edit Makefile instead." >> liblist
	@echo neurospaces nsintegrator | tr ' ' '\012' >> liblist

loadlib.c: liblist
	$(srcdir)/libsh < liblist > loadlib.c

move:
	mv nsgenesis $(top_srcdir)
	echo "Built negenesis!"
