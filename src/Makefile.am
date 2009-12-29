
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

bin_PROGRAMS = ns-sli 

ns_sli_SOURCES = \
	loadlib.c 

ns_sli_LDADD = \
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

ns_slitestdir=$(prefix)/ns-sli/tests
nobase_dist_ns_slitest_DATA=@TEST_SPECIFICATION_FILES@

ns_slidir=$(prefix)/ns-sli/

ns_slistartupdir=$(ns_slidir)/startup

liblist: Makefile
	@echo "# liblist - This file is generated automatically." > liblist
	@echo "#           DO NOT EDIT.  Edit Makefile instead." >> liblist
	@echo neurospaces nsintegrator ascfile olf hsolve | tr ' ' '\012' >> liblist

loadlib.c: liblist
	$(srcdir)/libsh < liblist > loadlib.c


install-data-local: 
	echo "*** Installing startup scripts to $(ns_slidir)"
	sudo cp -rf startup $(ns_slidir)

uninstall-local:
	rm -rf $(ns_slistartupdir)