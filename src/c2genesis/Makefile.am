utildir = $(top_srcdir)/src/util
scriptdir = $(top_srcdir)/src/script
shelldir = $(top_srcdir)/src/shell
simdir = $(top_srcdir)/src/sim

INCLUDES = -I$(utildir) -I$(shelldir) -I$(simdir) -I$(scriptdir) -I$(top_srcdir)/src

noinst_LIBRARIES = libshellc2genesis.a

noinst_PROGRAMS = c2genesis makestructs makelib makefunc

AM_CFLAGS = -DBSD -DLinux -DNEW -DNLIST_BUG -DTERMIO -DDONT_USE_SIGIO


libshellc2genesis_a_SOURCES = \
	$(shelldir)/shell_argv.c \
	$(shelldir)/shell_batch.c \
	$(shelldir)/shell_convert.c \
	$(shelldir)/shell_char.c \
	$(shelldir)/shell_debug.c \
	$(shelldir)/shell_edit.c \
	$(shelldir)/shell_env.c \
	$(shelldir)/shell_error.c \
	$(shelldir)/shell_esc.c \
	$(shelldir)/shell_exec.c \
	$(shelldir)/shell_func.c \
	$(shelldir)/shell_hash.c \
	$(shelldir)/shell_history.c \
	$(shelldir)/shell_info.c \
	$(shelldir)/shell_io.c \
	$(shelldir)/shell_job.c \
	$(shelldir)/shell_lib.c \
	$(shelldir)/shell_load.c \
	$(shelldir)/shell_log.c \
	$(shelldir)/shell_misc.c \
	$(shelldir)/shell_numeric.c \
	$(shelldir)/shell_ops.c \
	$(shelldir)/shell_prompt.c \
	$(shelldir)/shell_script.c \
	$(shelldir)/shell_setup.c \
	$(shelldir)/shell_sh.c \
	$(shelldir)/shell_status.c \
	$(shelldir)/shell_string.c \
	$(shelldir)/shell_sys.c \
	$(shelldir)/shell_tty.c \
	$(shelldir)/null_startup.c

c2genesis_SOURCES = \
	c2genesis.c

c2genesis_LDADD = \
	./libshellc2genesis.a \
	$(utildir)/libutil.a \
	$(scriptdir)/libscript.a \
	-lfl \
	-lncurses \
	-lm



makestructs_SOURCES = makestructs.c

makelib_SOURCES = makelib.c

makefunc_SOURCES = makefunc.c
