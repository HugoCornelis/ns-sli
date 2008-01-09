sysdir = $(top_srcdir)/src/sys
ssdir = $(top_srcdir)/src/ss
shelldir = $(top_srcdir)/src/shell
simdir = $(top_srcdir)/src/sim

INCLUDES = -I$(sysdir) -I$(ssdir) -I$(shelldir) -I$(simdir) -I$(top_srcdir)/src


noinst_LIBRARIES = libshellcodeg.a libshell.a

AM_CFLAGS = -DBSD -DLinux -DNEW -DNLIST_BUG -DTERMIO -DDONT_USE_SIGIO

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


libshellcodeg_a_SOURCES = \
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
	null_startup.c
