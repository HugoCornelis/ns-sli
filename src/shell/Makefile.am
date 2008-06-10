utildir = $(top_srcdir)/src/util
scriptdir = $(top_srcdir)/src/script
shelldir = $(top_srcdir)/src/shell
simdir = $(top_srcdir)/src/sim
c2genesis = $(top_srcdir)/src/c2genesis/c2genesis

INCLUDES = -I$(utildir) -I$(shelldir) -I$(simdir) -I$(scriptdir) -I$(top_srcdir)/src

noinst_LIBRARIES = libshell.a

AM_CFLAGS = -DBSD -DLinux -DNEW -DNLIST_BUG -DTERMIO -DDONT_USE_SIGIO

BUILT_SOURCES = \
	shell_g@.c \
	shell_g@.h

shell_g@.c:
	$(c2genesis) shelllib.g shell_ext.h shell -novar


noinst_HEADERS = \
	iofunc.h \
	NULLArgv.h \
	shell_defs.h \
	shell_ext.h \
	shell_func_ext.h \
	shell.h \
	shell_struct.h



libshell_a_SOURCES =	\
	shell_argv.c \
	shell_batch.c \
	shell_convert.c \
	shell_char.c \
	shell_debug.c \
	shell_edit.c \
	shell_env.c \
	shell_error.c \
	shell_esc.c \
	shell_exec.c \
	shell_func.c \
	shell_hash.c \
	shell_history.c \
	shell_info.c \
	shell_io.c \
	shell_job.c \
	shell_lib.c \
	shell_load.c \
	shell_log.c \
	shell_misc.c \
	shell_numeric.c \
	shell_ops.c \
	shell_prompt.c \
	shell_script.c \
	shell_setup.c \
	shell_sh.c \
	shell_status.c \
	shell_string.c \
	shell_sys.c \
	shell_tty.c \
	shell_g@.c  




CLEANFILES = \
	shell_g@.c \
	shell_g@.h

