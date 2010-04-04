SUBDIRS = 

utildir = $(top_builddir)/src/util
scriptdir = $(top_builddir)/src/script
shelldir = $(top_builddir)/src/shell
simdir = $(top_builddir)/src/sim
nsdir = $(top_builddir)/src/neurospaces
olfdir = $(top_builddir)/src/olf


#t the following rules are crap complete, would be good if a auto
#t expert takes a look at it.

dist-hook:
	cp $(srcdir)/sli.i $(distdir)
	cp $(srcdir)/sli_test.pm $(distdir)

swigdir = $(prefix)/glue/swig

#t use $(swigdir) here

perldir = $(prefix)/glue/swig/perl

swig_DATA = sli.i

nobase_perl_HEADERS = SLI.pm SLI/Integrators/Commands.pm

perl_DATA = sli_test.pm SwiggableSLI.pm SwiggableSLI.$(PERLLIB_EXTENSION)

BUILT_SOURCES = \
	SwiggableSLI.pm \
	swiggable_sli_wrap.c

SwiggableSLI.pm swiggable_sli_wrap.c: $(swig_DATA)
	swig -I/usr/local/neurospaces/instrumentor -I$(srcdir)/../../.. -I$(top_builddir) -perl5 -makedefault -module SwiggableSLI -o swiggable_sli_wrap.c $(srcdir)/sli.i

#t the configuration should say if this depends on neurospaces or not

swiggable_sli_wrap.o: swiggable_sli_wrap.c
	$(SWIGCOMPILECOMMAND_PERL)


SwiggableSLI.$(PERLLIB_EXTENSION): swiggable_sli_wrap.o
	$(SWIGLINKCOMMAND_PERL)





all: SwiggableSLI.$(PERLLIB_EXTENSION)

CLEANFILES = \
	SwiggableSLI.pm \
	swiggable_sli_wrap.c \
	swiggable_sli_wrap.o \
	SwiggableSLI.$(PERLLIB_EXTENSION)

#TESTS = sli_test.pm

test: check

