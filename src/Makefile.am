SUBDIRS = util script c2genesis shell neurospaces par sim

utildir = $(top_srcdir)/src/util
scriptdir = $(top_srcdir)/src/script
shelldir = $(top_srcdir)/src/shell
simdir = $(top_srcdir)/src/sim
pardir = $(top_srcdir)/src/par
nsdir = $(top_srcdir)/src/neurospaces

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
	-lfl \
	-lreadline \
	-lhistory \
	-lm \
	-lncurses

move:
	mv nsgenesis $(top_srcdir)
	echo "Built negenesis!"
