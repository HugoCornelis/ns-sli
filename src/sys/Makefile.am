
sysdir = $(top_srcdir)/src/sys
ssdir = $(top_srcdir)/src/ss
shelldir = $(top_srcdir)/src/shell

noinst_PROGRAMS = code_lib code_func code_sym code_g

INCLUDES = -I$(sysdir) -I$(ssdir) -I$(shelldir)

code_lib_SOURCES = code_lib.c
code_func_SOURCES = code_func.c
code_sym_SOURCES = code_sym.c

code_g_LDADD = \
	-lfl \
	-L/usr/local/lib/neurospacesread \
	-lneurospacesread \
	-L/usr/local/lib/neurospaces/algorithms/symbol \
	-lsymbol_algorithms \
	-lreadline \
	-lhistory \
	-lncurses \
	-lm 
