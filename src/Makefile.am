
SUBDIRS = util script c2genesis shell neurospaces olf sim 

utildir = $(top_builddir)/src/util
scriptdir = $(top_builddir)/src/script
shelldir = $(top_builddir)/src/shell
simdir = $(top_builddir)/src/sim
nsdir = $(top_builddir)/src/neurospaces
olfdir = $(top_builddir)/src/olf

EXTRA_DIST = \
	libsh 

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
	$(olfdir)/libolf.a \
	$(nsdir)/libneurospaces.a \
	-L${libdir}/model-container -lneurospacesread \
	-L${libdir}/neurospaces/algorithms/symbol -lsymbol_algorithms \
	-L${libdir}/heccer -lheccer \
	-L${libdir}/heccer -lhneurospaces \
	$(SYSLIBLINKS)

# add the tests/ directory because the TEST_SPECIFICATION_FILES has
# $(top_srcdir) as prefix, which points to ../ compensating for tests/.

nsgenesistestdir=$(prefix)/nsgenesis/tests
nobase_dist_nsgenesistest_DATA=@TEST_SPECIFICATION_FILES@

liblist: Makefile
	@echo "# liblist - This file is generated automatically." > liblist
	@echo "#           DO NOT EDIT.  Edit Makefile instead." >> liblist
	@echo neurospaces nsintegrator ascfile olf hsolve | tr ' ' '\012' >> liblist

loadlib.c: liblist
	$(srcdir)/libsh < liblist > loadlib.c

