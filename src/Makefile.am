
SUBDIRS = util script c2genesis shell neurospaces olf sim 

utildir = $(top_builddir)/src/util
scriptdir = $(top_builddir)/src/script
shelldir = $(top_builddir)/src/shell
simdir = $(top_builddir)/src/sim
nsdir = $(top_builddir)/src/neurospaces
olfdir = $(top_builddir)/src/olf

EXTRA_DIST = \
	$(srcdir)/libsh \
	$(srcdir)/startup

AM_CLAGS=-DPLAINTERM

BUILT_SOURCES = \
	$(srcdir)/loadlib.c \
	$(srcdir)/liblist

CLEANFILES = \
	$(srcdir)/loadlib.c \
	$(srcdir)/liblist

bin_PROGRAMS = ns-sli 


ns_sli_INCLUDES = -I$(utildir) -I$(shelldir) -I$(simdir) -I$(scriptdir) -I$(olfdir) -I(nsdir) -I${prefix}/neurospaces/instrumentor

ns_sli_SOURCES = \
	$(srcdir)/loadlib.c 

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
	$(srcdir)/libsh < $(srcdir)/liblist > $(srcdir)/loadlib.c


install-data-local: 
	echo "*** Installing startup scripts to $(ns_slidir)"
	cp -rf $(top_builddir)/src/startup $(ns_slidir)
	cp -rf $(top_builddir)/tests/scripts $(ns_slidir)/tests

uninstall-local:
	rm -rf $(ns_slistartupdir)
	rm -rf $(ns_slidir)