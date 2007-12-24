# $Id: Makefile.dist,v 1.39 2006/03/18 00:49:35 svitak Exp $
#
#				G E N E S I S
#		    The General Neural Simulation System
#				 Version 2.3
#
# SYNOPSIS: This is the top-level Makefile for GENESIS.  
#           YOU MUST EDIT THIS FILE BEFORE RUNNING "make".
#           Please follow the procedure given below.
#
# TABLE OF CONTENTS
# A. Procedure for building and installing GENESIS
# B. Installation configuration settings
# C. Optional libraries
# D. Definitions for specific operating system and compiler in use
# E. Custom settings
# F. Beginning of non-configurable definitions
# G. Revision history
#
# ----------------------------------------------------------------------
# A. PROCEDURE FOR BUILDING AND INSTALLING GENESIS
# ----------------------------------------------------------------------
#
# 1) Examine the small block of definitions in section B which may need
#    to be modified for your architecture.
#
# 2) Look through the rest of this file for a block of definitions for
#    your particular computer operating system and compiler combination.
#    For example, the definitions suggested for Solaris 2.x when using
#    the Sun Workshop C compiler begins with lines that look like this:
#
#		# System:	Solaris 2.x (A.K.A. SunOS 5.x)
#		# Compiler:	Sun Workshop "cc"
#
#    Note that some system/compiler combinations have several variations
#    below, so look carefully at all of them before chosing one.
#
# 3) Uncomment the definitions for your operating system/compiler
#    combination. Please be sure to remove the comment character (#) as well
#    as any leading spaces.
#
#    NOTE: MAKE SURE THAT NO OTHER SYSTEM/COMPILER SECTION IS UNCOMMENTED.
#
# 4) Execute the command "make".
#
# 5) Execute the command "make install".
# 
# 6) Execute the command "make clean".
#
# 
# ADDITIONAL INFORMATION:
# If you run into problems compiling this package, consult the "CUSTOM
# SETTINGS" section below, where you may override the default settings.
# If one of the optional libraries fails to compile, comment out the
# library's macros in the "Optional libraries" section.
#
# GENESIS can also be built without the XODUS graphics libraries by
# replacing the commands in steps 2 and 3 with "make nxall" and
# "make nxinstall".  A GENESIS without any libraries can be built
# with the commands "make minall" and "make mininstall".
#

# ----------------------------------------------------------------------
# B. INSTALLATION AND MISC CONFIGURATION SETTINGS
# ----------------------------------------------------------------------

# The following variable determines where GENESIS is placed by the
# "make install" command. Substituting the full path here is preferable
# to using `pwd`.
INSTALLDIR	=	`pwd`/..

# If /tmp is not big enough to contain compile-produced object files,
# choose a different location here.
TMPDIR = /tmp


# ----------------------------------------------------------------------
# C. OPTIONAL LIBRARIES
# ----------------------------------------------------------------------
#
# The following libraries are optional.  If you comment the macros for a
# given library here the library will not be compiled or linked into the
# executable.

#
# kinetics --- Kinetic modeling library (necessary for kkit)
#

KINETICSLIB = kin
KINETICSDIR = kinetics
KINETICSOBJ = $(KINETICSDIR)/kinlib.o



#
# neurospaces --- An alternative model container.
#
NEUROSPACESLIB = neurospaces
NEUROSPACESDIR = neurospaces
NEUROSPACESOBJ = $(NEUROSPACESDIR)/neurospaceslib.o

#
# diskio --- Binary file format support library
#
# The diskio and related objects from this library provide a disk_in
# disk_out backward compatible interface for netCDF portable binary
# files.  Comment out the DISKIO and DISKIOLIB macros to exclude the
# diskio library.  There are currently no kits or tutorials which depend
# on this library.

# Please note that all the macros here need to be uncommented if diskio
# support is to be included.  FMT1 support is therefore included by
# default when the diskio library is linked in.

FMT1SUBDIR   = FMT1
FMT1OBJ      = $(DISKIODIR)/interface/FMT1/FMT1lib.o
FMT1FLAGS    = -DFMT1

DISKIOLIB    = diskio
DISKIODIR    = diskio
DISKIOSUBDIR = $(NETCDFSUBDIR) \
               $(FMT1SUBDIR)
DISKIOOBJ    = $(NETCDFOBJ) \
	       $(FMT1OBJ) \
	       $(DISKIODIR)/diskiolib.o
DISKIOFLAGS  = $(NETCDFFLAGS) \
	       $(FMT1FLAGS)

# Uncomment the following definitions if the netCDF file format needs to
# be supported by diskio.  netCDF is a system-independent, portable,
# binary file format.  See the directory src/diskio/interface/netcdf for
# more information.  NOTE: *only* uncomment the netCDF definitions below
# if diskio support is included above.

NETCDFSUBDIR = netcdf
NETCDFOBJ = \
	$(DISKIODIR)/interface/$(NETCDFSUBDIR)/netcdflib.o \
	$(DISKIODIR)/interface/$(NETCDFSUBDIR)/netcdf-3.4/src/libsrc/libnetcdf.a
NETCDFFLAGS = -Dnetcdf

#
# oldconn --- GENESIS 1.4 network connection compatibility library
#

# The following is only necessary for GENESIS 1.4 network models
# minimally ported to GENESIS 2.x.  NOTE: some of the tutorials/demos
# utilize this library.

OLDCONNLIB = axon synapse personal toolconn simconn
OLDCONNDIR = oldconn
OLDCONNOBJ = $(OLDCONNDIR)/axon/axonlib.o \
	     $(OLDCONNDIR)/synapse/synlib.o \
	     $(OLDCONNDIR)/personal/perlib.o \
	     $(OLDCONNDIR)/sim/simconnlib.o \
	     $(OLDCONNDIR)/tools/toolconnlib.o

# 
# SPRNG -- Improved random number generation
#

# The SPRNG library provides five random number generators.  To use
# SPRNG, you must specify SPRNG as one and only one of lfg, lcg,
# lcg64, or cmrg here.  Lagged Fibonacci is the default as it is the
# fastest and has the longest number sequence.
#
# Further information about SPRNG can be found at http://sprng.cs.fsu.edu/
# The link to the users guide to installation on various platforms
# (http://daniel.scri.fsu.edu/www/version1.0/platforms.html) may be useful
# to address compilation problems with the SPRNG 1 version used in GENESIS.
# 
# Note that lfg is the default and is the most tested.

SPRNG_LIB = lfg

# Disable compiling of SPRNG by uncommenting the following line and
# commenting out all the other SPRNG lines below.  If GENESIS has
# already been compiled, you'll have to do "make clean" before making
# GENESIS again.
#
# SPRNG_FLAG=
#

#SPRNG_FLAG = -DINCSPRNG
#SPRNGDIR   = sprng
#SPRNGLIB   = $(SPRNGDIR)/lib/lib$(SPRNG_LIB).a

# ----------------------------------------------------------------------
# D. DEFINITIONS FOR SPECIFIC OPERATING SYSTEM AND COMPILER IN USE
# ----------------------------------------------------------------------
#
# Below are some compiler dependent settings for various system/compiler
# combinations. Uncomment the appropriate macro settings for your system
# and compiler combination.
#
# If you are planning on using math optimization flags, please see the
# README. In particular, any gcc options which set -funsafe-math-optimizations
# (e.g. -ffast-math) will break parts of GENESIS.
#

# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:      SunOS 4.1.x
# Compiler:    SunOS 4.1.x "cc"
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

# MACHINE=sun4
# OS=BSD

# XINCLUDE=-I/usr/include
# XLIB=/usr/lib

# CC=cc
# CPP=/lib/cpp -P
# CFLAGS=-O -temp=$(TMPDIR)
# LD=ld

## NOTE: If you get unresolved references for X11 library symbols in the
## final link step during compilation, add
##
##    -Bstatic
##
## to the LDFLAGS definition here.  This is a documented problem with
## X11 and SunOS shared libraries.  If you want information on fixes for
## this problem look for faq #112 in:
##
##    http://www.x.org/ftp/contrib/faqs/x-faq-multipart/x-faq-5
##

# LDFLAGS=

# RANLIB=ranlib
# AR=ar

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= $(LEXLIB) -lm

# TERMCAP=-ltermcap
# TERMOPT=-DTERMIO

## end SunOS 4.1.x


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	Solaris 2.x (A.K.A. SunOS 5.x)
# Compiler:	Sun Workshop "cc"
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

# MACHINE=Solaris
# OS=SYSV

# XINCLUDE=-I/usr/openwin/include
# XLIB=/usr/openwin/lib

## Note: Do not increase the optimization level higher than -xO1, at least
## for version "WorkShop Compilers 5.0 98/12/15 C 5.0".  Higher levels cause
## at least one of the XODUS widgets to fail to work properly, even though no
## compilation errors are reported.  GCC at higher optimization levels does
## not exhibit this problem.

## probably in /opt/SUNWspro/bin, but there may be a symbolic link from
## /usr/ccs/bin.
# CC=cc
# CFLAGS=-Xt -xO1 -xlibmil -xprefetch -DBIGENDIAN
# CPP = cpp -P

## ld is probably in /usr/ccs/bin.
# LD=ld
# LDFLAGS=

# RANLIB=ranlib
# AR=ar

## You may choose to use bison and/or flex here instead of the
## Sun-supplied yacc and/or lex.  If so, uncomment the following lines,
## and comment out the default yacc/lex definitions further below.
##
## YACC = bison -y
##
## LEX = flex -l
## LEXLIB = -L<flex-lib-path> -lfl
## LIBS= $(LEXLIB) -lm

## NOTE: In Solaris 2.4 through Solaris 2.6, the Sun-issued "yacc"
## appears to produce code that interacts badly with the Sun Workshop
## "cc" compiler when compiling the GENESIS yacc files.  If you are
## running a version of Solaris prior to Solaris 2.7, you will need to
## obtain the GNU bison distribution (see ftp://ftp.gnu.org), compile
## it, install it on your system, then uncomment the following lines
## (the ones with "bison" in them) and also comment out the use of
## "yacc" further below.  (We have successfully compiled GENESIS on
## Solaris 2.7 using the Sun-supplied yacc, so we don't believe you need
## to use bison for Solaris 2.7.)
##
## If you have a version of Solaris before 2.7, you will also need to
## obtain the GNU "flex" distribution (see ftp://ftp.gnu.org), compile
## it, install it, then uncomment the following lines and comment out
## the use of "lex" below.  Substitute the location of the flex library
## on your system for <flex-lib-path> (or remove -L<flex-lib-path> if
## the library is installed in a standard library path).
##
## YACC = bison -y
##
## LEX = flex -l
## LEXLIB = -L<flex-lib-path> -lfl
## LIBS= $(LEXLIB) -lm
##
## If you are using Solaris 2.7 or later, leave the YACC and LEX lines above
## commented out, and uncomment the following lines instead:

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= $(LEXLIB) -lm

# TERMCAP=-ltermcap
# TERMOPT=-DTERMIO -DDONT_USE_SIGIO

## end	Solaris 2.x (aka SunOS 5.x) using Sun Workshop C compiler


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	Solaris 2.x, 9 (A.K.A. SunOS 5.x)
# Compiler:	GCC 2.8.1, 3.3.2
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

## NOTE:  There have been reports that GCC versions 3.x produce
## errors when the code_g program is compiled using optimization
## level O2.  If you encounter this problem, change the CFLAGS line
## below to read 'CFLAGS=-O -DBIGENDIAN'.

# MACHINE=Solaris
# OS=SYSV

# XINCLUDE=-I/usr/openwin/include
# XLIB=/usr/openwin/lib

# CC=gcc
# CFLAGS=-O2 -DBIGENDIAN

## Avoid using a full path to cpp if possible. If you can't find it
## in a bin directory, as a last resort try /usr/ccs/lib/cpp
# CPP=cpp -P

## ld is probably in /usr/ccs/bin.
# LD=ld
# LDFLAGS=

# RANLIB=ranlib
# AR=ar

## You may choose to use bison and/or flex here instead of the
## Sun-supplied yacc and/or lex.  If so, uncomment the following lines,
## and comment out the default yacc/lex definitions further below.
##
## YACC = bison -y
##
## LEX = flex -l
## LEXLIB = -L<flex-lib-path> -lfl
## LIBS= $(LEXLIB) -lm

## lex and yacc are probably in /usr/ccs/bin.
# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= $(LEXLIB) -lm

# TERMCAP=-ltermcap
# TERMOPT=-DTERMIO -DDONT_USE_SIGIO

## end	Solaris 2.x (aka SunOS 5.x) using GCC 2.8.1 compiler


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	SGI Irix 6.5
# Compiler:	SGI C compiler (producing new-style 32 bit executables)
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

## The settings in this section are for N32 mode, the SGI "new" style
## 32-bit executables with N64 calling conventions and optimizations.
## They are current as of IRIX 6.5.3 and 6.5.8, tested on R10000-based
## Octane and O2 systems using the MIPSPro compiler version 7.30.
## There is a separate section below for 64-bit executables.

# MACHINE = irix
# OS = SYSV

# XINCLUDE = -I/usr/include
# XLIB = .

# CC = cc
# CPP = /lib/cpp -P

# CFLAGS = -n32 -xansi -signed -O2 -DBIGENDIAN -OPT:Olimit=6000 $(IRIX_WARN)

# IRIX_HACK = -w
# LDFLAGS = -n32 -L/usr/lib32 -LD_MSG:off=85,134
# LD = ld

## There is typically no ranlib on Irix systems. 'ar -s' creates the symbol
## table used by ld.
# RANLIB = ranlib
# AR = ar

# YACC = yacc
# LEX = lex
# LEXLIB = -ll
# LIBS = $(LEXLIB) -lm

# TERMCAP = -lcurses
# TERMOPT = -DTERMIO -DDONT_USE_SIGIO

## UNCOMMENT ONLY ONE OF THE FOLLOWING.
##
## If you are using IRIX >= 6.5.8, uncomment the next IRIX_WARN line:
##
# IRIX_WARN = -woff 1116,1552,1174,3434
##
## If you are using IRIX above 6.5.3 but less than 6.5.8, use the following:
##
# IRIX_WARN = -woff 1048,1116,1155,3170
##
## Explanation of the above: the CFLAGS and LDFLAGS settings
## purposefully disable reporting of certain kinds of warnings via the
## -woff option, because they are either silly warnings, or else things
## we cannot fix because they are in code imported from elsewhere (e.g.,
## netCDF), or else things that could be fixed but are not worth it at
## this time.  Yes, we know this is poor practice, but given limited
## resources, it's the best we can do.

## end SGI IRIX 6.5.x new-style 32-bit


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	SGI Irix 6.5
# Compiler:	SGI C compiler (producing old-style 32-bit executables)
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

## The settings in this section are for O32 mode, the SGI "old" style
## 32-bit executables.  They are current as of IRIX 6.5.3 and 6.5.8,
## tested on R10000-based Octane and O2 systems.

# MACHINE = irix
# OS = SYSV

# XINCLUDE = -I/usr/include
# XLIB = .

# CC = cc
# CPP = /lib/cpp -P

# CFLAGS = -o32 -xansi -signed -O2 -DBIGENDIAN -Olimit 6000 -Wl,-woff,85 -Wl,-woff,134
# IRIX_HACK = -w
# LDFLAGS = -o32 -cckr
# LD = ld

# RANLIB = ranlib
# AR = ar

# YACC = yacc
# LEX = lex
# LEXLIB = -ll
# LIBS = $(LEXLIB) -lm

# TERMCAP = -lcurses
# TERMOPT = -DTERMIO -DDONT_USE_SIGIO

## end SGI IRIX 6.5.x old-style 32-bit


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	SGI Irix 6.4
# Compiler:	SGI C compiler (producing old-style 32-bit executables)
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

## This configuration has not been tested by the Caltech GENESIS group since
## the introduction of IRIX 6.5.  If you have a 6.4 system and encounter
## trouble here, please mail genesis@genesis-sim.org.

# MACHINE=irix
# OS=SYSV

# XINCLUDE=-I/usr/include
# XLIB=/usr/lib

# CC=cc -32
# CPP=/lib/cpp -P
# CFLAGS=-cckr -O -G 0 -DBIGENDIAN
# IRIX_HACK = -w

# LD=ld -32
# LDFLAGS= -O

# RANLIB=ranlib
# AR=ar

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= $(LEXLIB) -lm

# TERMCAP=
# TERMOPT=-DPLAINTERM

## end SGI IRIX 6.4 32-bit


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	SGI Irix 6.5
# Compiler:	SGI C compiler (producing 64-bit executables)
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

## This configuration is known to work for (and has only been tested on)
## SGI Origin 2000 running IRIX 6.5.10 with MIPSPro compiler 7.3.1.1m (or .3m), 
## gcc 2.95, or gcc 3.0.4. It may work for other architectures and OS versions, but the
## GENESIS maintainers do not have experience with other combinations.
## If using the MIPSPro compiler, you might need to change "-xansi" to "-cckr"
## in the CFLAGS line below.  Please mail genesis@genesis-sim.org if you use
## these settings and tell us about it. If these settings do not work for you,
## the "new-style 32-bit binary" settings above should still work (but more
## slowly).
##

# MACHINE=irix
# OS=SYSV

# XINCLUDE=-I/usr/include
# XLIB=/usr/lib64

# CC=cc 
# CPP=/lib/cpp -P
# CFLAGS=-xansi -mips4 -64 -LNO -G 0 -r10000 -O2 -Ddecalpha -DBIGENDIAN -DLONGWORDS -OPT:Olimit=6000 $(IRIX_WARN)
# IRIX_HACK =-w
# LD=ld 
# LDFLAGS=-mips4 -64 -G 0

# RANLIB=ranlib
# AR=ar

## It appears safest to use bison and flex instead of yacc and lex.
## See the README file for information on obtaining bison and flex.
## However, many IRIX 6.5 systems have flex, but do not have the library file
## libfl.a.  The line 'LEXLIB=-ll' below tells the the compiler to look for
## the file libl.a, instead.  If it should turn out that you have libfl.a, but
## not libl.a, change the line to read  'LEXLIB=-lfl'.
## If you want to try yacc and lex, change these defines to be like
## those in the 32 bit section.

# YACC=bison -y
# LEX=flex -l
# LEXLIB=-ll
# LIBS= $(LEXLIB) -lm

# TERMCAP=
# TERMOPT=-DPLAINTERM

# IRIX_WARN = -woff 1116,1168,1174,1177,1552
##
## Explanation of the above: the CFLAGS and LDFLAGS settings
## purposefully disable reporting of certain kinds of warnings via the
## -woff option, because they are either silly warnings, or else things
## we cannot fix because they are in code imported from elsewhere (e.g.,
## netCDF), or else things that could be fixed but are not worth it at
## this time.  Yes, we know this is poor practice, but given limited
## resources, it's the best we can do.

## end SGI IRIX 6.x 64-bit


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	SGI IRIX 4.x
# Compiler:	SGI C compiler
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

# MACHINE=irix
# OS=SYSV

# XINCLUDE=-I/usr/include
# XLIB=/usr/lib

# CC=cc -cckr -G 5
# CPP=/lib/cpp -P
# CFLAGS=-O -DBIGENDIAN
# IRIX_HACK = -w
# LD=ld
# LDFLAGS=-G 5

# RANLIB=ranlib
# AR=ar

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= $(LEXLIB) -lm

# TERMCAP=
# TERMOPT=-DPLAINTERM

## end SGI IRIX 4.x


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	DECStation running Ultrix 4.x or 3.x
# Compiler:	DEC C compiler
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

# MACHINE=mips
# OS=BSD

# XINCLUDE=-I/usr/include
# XLIB=/usr/lib

## You might have to play with the value of the -G option to get
## GENESIS to compile/link properly.

# CC=cc -G 5
# CPP=/lib/cpp -P
# CFLAGS=-O
# LD=ld
# LDFLAGS=-G 5

# RANLIB=ranlib
# AR=ar

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= $(LEXLIB) -lm

# TERMCAP=-ltermcap
# TERMOPT=-DTERMIO

## end DECStation running Ultrix 4.x or 3.x


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	DEC Alpha running Digital UNIX version 4
# Compiler:	DEC cc compiler
#
# This combination is known to FAIL.  Support is presently unavailable.
# If you succeed in getting this to work yourself, please send your
# changes back to the GENESIS developers.
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

# MACHINE=decalpha
# OS=BSD

# XINCLUDE=-I/usr/include
# XLIB=/usr/lib

# CC=cc -std
# CPP=/lib/cpp -P
# CFLAGS=-O2 -DLONGWORDS
# LD=ld
# LDFLAGS=

# RANLIB=ranlib
# AR=ar

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= -ldnet_stub $(LEXLIB) -lm

# TERMCAP=-ltermcap
# TERMOPT=-DTERMIO -DDONT_USE_SIGIO

## end	DEC Alpha running OSF/1 release 2 or higher


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	DEC Alpha running Digital UNIX version 3.2
# Compiler:	DEC cc compiler
#
# This combination is known to FAIL.  Support is presently unavailable.
# If you succeed in getting this to work yourself, please send your
# changes back to the GENESIS developers.
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

# MACHINE=decalpha
# OS=BSD

# XINCLUDE=-I/usr/include
# XLIB=/usr/lib

# CC=cc
# CPP=/lib/cpp -P
# CFLAGS=-g -std0 -taso -DLONGWORDS # -Olimit 5000
# LD=ld
# LDFLAGS=

# RANLIB=ranlib
# AR=ar

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= -ldnet_stub $(LEXLIB) -lm

# TERMCAP=-ltermcap
# TERMOPT=-DTERMIO -DDONT_USE_SIGIO

## end	DEC Alpha running OSF/1 release 2 or higher


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	DEC Alpha OSF1/Digital UNIX version 3.2
# Compiler:	GNU GCC (egcs-2.91.66, egcs-1.1.2 release)
#
# This combination is known to FAIL.  Support is presently unavailable.
# If you succeed in getting this to work yourself, please send your
# changes back to the GENESIS developers.
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

# MACHINE=decalpha
# OS=BSD

# XINCLUDE=-I/usr/X11R6/include
# XLIB=/usr/lib

# CC=gcc
# CPP=/lib/cpp -P
# CFLAGS=-g -DLONGWORDS
# LD=ld
# LDFLAGS=

# RANLIB=ranlib
# AR=ar

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= -ldnet_stub $(LEXLIB) -lm

# TERMCAP=-ltermcap
# TERMOPT=-DTERMIO -DDONT_USE_SIGIO

## end	DEC Alpha running OSF/1 release 2 or higher


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	DEC Alpha running OSF/1 release 2 or higher
# Compiler:	DEC cc compiler
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

# MACHINE=decalpha
# OS=BSD

# XINCLUDE=-I/usr/include
# XLIB=/usr/lib

## The c89 compiler doesn't compile cleanly across alpha OS releases.
## Under OSF/1 v2  the -O option results in runtime problems in Xodus.
## The -O problem may also exist for OSF/1 v3 systems.

# CC=cc -std0
# CPP=/lib/cpp -P
# CFLAGS=-O -DLONGWORDS
# LD=ld
# LDFLAGS=

# RANLIB=ranlib
# AR=ar

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= -ldnet_stub $(LEXLIB) -lm

# TERMCAP=-ltermcap
# TERMOPT=-DTERMIO -DDONT_USE_SIGIO

## end	DEC Alpha running OSF/1 release 2 or higher


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	Cray XT3 (as installed at Pittsburgh Supercomputing Center)
# Compiler:	Portland Group cc
#
#	see Makefile.xt3 for other important settings
#
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

# MACHINE=xt3
# OS=BSD

# XINCLUDE=-I/usr/include
# XLIB=/usr/lib

# CC=cc -target=catamount
# CPP=cpp -P  # NOTE: we really should be using "cc -E" here, but the PGI cc
              #   compiler does not recognize files with extension .h as being
              #   source files, so we use the gcc preprocessor.  We can get
              #   away with this because the files to which CPP is applied
              #   do not include any OS-specific .h files
# CFLAGS=-O3 -Mnontemporal -Mprefetch=distance:8,nta -Minfo=loop -D__NO_MATH_INLINES -DXT3
# LD=ld
# RANLIB=echo
# AR=ar
# YACC=bison -y
# LEX=flex -l
# LEXLIB=-lfl
# LIBS= $(LEXLIB) -lm
# TERMCAP=
# TERMOPT=-DPLAINTERM -DDONT_USE_SIGIO

# end	Cray XT3 (as installed at Pittsburgh Supercomputing Center)


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	Linux 1.2.x and up on Intel x86-based, Xeon,
#           and AMD 64-bit systems.
# Compiler:	GCC
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

## 2000-05-23
## Termcap/ncurses issues: The shell library makes reference to the
## termcap library.  Some Linux distributions have an ncurses library
## which includes termcap emulation.  GENESIS appears to work
## properly with the ncurses supplied with Red Hat Linux 5.1 and higher
## and Debian Linux (glibc2.1, egcs-2.91.66).  However, linking with
## ncurses is known to have resulted in core dumps in GENESIS in older
## Linux versions.
##
## If you encounter problems linking with the TERMCAP flags listed below
## or the GENESIS command line interface does not work, try the
## following alternatives:
##
## 1) TERMCAP = -ltermcap
##
## 2) (If you are using SuSE Linux)
##    TERMCAP = /usr/lib/termcap/libtermcap.a
##
## 3) (If you are using Red Hat Linux prior to version 6.0)
##    TERMCAP = /usr/lib/libtermcap.a
##

 MACHINE=Linux
 OS=BSD

 XINCLUDE=-I/usr/X11R6/include

## Choose ONE XLIB line to uncomment:
## For 32-bit architectures
 XLIB=/usr/X11R6/lib
## For 64-bit machines, probably need /usr/X11R6/lib64 here.
# XLIB=/usr/X11R6/lib64

 CC=cc

## Old (and probably broken) gcc installations may need the full
## path to cpp (preferably NOT one in /lib). If there isn't a 
## [link to] cpp in the same directory as 'cc', you should consider
## [re]installing a newer gcc.

 CPP=cpp -P

## Choose ONE CFLAGS line to uncomment:
## For 32-bit architectures
 CFLAGS=-D__NO_MATH_INLINES -g
## For 64-bit architectures
# CFLAGS=-O2 -D__NO_MATH_INLINES -DLONGWORDS

 LD=ld

## !!!
## Don't uncomment the next line unless you get errors about
## libraries not being found. Setting this path may interfere with
## the default (probably correct) operation of the loader, but some
## 64-bit architectures may need /usr/lib64 here.
## LDFLAGS=-L/usr/lib

 RANLIB=ranlib
 AR=ar

 YACC=bison -y
 LEX=flex -l
 LEXLIB=-lfl -L /usr/local/lib/neurospacesread -lneurospacesread -L /usr/local/lib/neurospaces/algorithms/symbol -lsymbol_algorithms -lreadline -lhistory
## Some linuxes (Gentoo?) may require -lSM and -lICE as well.
 LIBS= $(LEXLIB) -lm

 TERMCAP=-lncurses
 TERMOPT=-DTERMIO -DDONT_USE_SIGIO

## end	Linux 1.2.x and up on Intel x86-based systems


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	Linux 2.x and up on PPC-based systems (LinuxPPC)
# Compiler:	GCC
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

## This configuration was provided by a GENESIS user, Alfonso
## Delgado-Reyes.  Please make sure that you have up-to-date and
## complete installations of flex and bison if you are using this
## configuration.

## If you encounter problems linking with the TERMCAP flags listed below
## or the GENESIS command line interface does not work, try the
## following alternatives:
##
## 1) TERMCAP = -ltermcap
##
## 2) TERMCAP = /usr/lib/termcap/libtermcap.a
##
## 3) TERMCAP = /usr/lib/libtermcap.a

# MACHINE=LinuxPPC
# OS=BSD

# XINCLUDE=-I/usr/X11R6/include
# XLIB=/usr/X11R6/lib

# CC=cc
# CPP=/lib/cpp -P
# CFLAGS=-O2 -D__NO_MATH_INLINES

# LD=ld
# LDFLAGS=-L/usr/lib

# RANLIB=ranlib
# AR=ar

# YACC=bison -y
# LEX=flex -l
# LEXLIB=-lfl
# LIBS= $(LEXLIB) -lm

# TERMCAP=-lncurses
# TERMOPT=-DTERMIO -DDONT_USE_SIGIO

## end	Linux 2.x and up on PPC-based systems (LinuxPPC)

# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:       MacOS X and Darwin (PPC-based systems)
# Compiler:     Apple Computer, Inc. v.gcc-932.1, based on gcc v.2.95.2
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

## This configuration was originally provided by a GENESIS user, Alfonso
## Delgado-Reyes.

# MACHINE=MacOSXDarwin
# OS=BSD

# XINCLUDE=-I/usr/X11R6/include
# XLIB=/usr/X11R6/lib

# CC=cc
# CPP=cpp -P 
# CFLAGS=-O2 -D__NO_MATH_INLINES -DBIGENDIAN

# LD=ld
# LDFLAGS=

# RANLIB=ranlib
# AR=ar

## Use 'yacc' or 'bison -y' here.
# YACC=yacc

## Use lex or 'flex -l' here.
# LEX=lex

## If using flex, LEXLIB will be '-lfl'.
# LEXLIB=-ll

## OSX 10.3.9 may require that '-lSM -lICE' be added to LIBS
# LIBS= $(LEXLIB)
 
# TERMCAP=-lcurses
# TERMOPT=-DTERMIO -DDONT_USE_SIGIO

## end  MacOS X and Darwin (PPC-based systems)

# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	FreeBSD 4.1
# Compiler:	GCC C compiler
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

## FreeBSD comes with Berkeley yacc and is used here.  A fix in the yacc
## specs allows this version of yacc to work where it failed under Linux
## systems with Berkeley yacc.  The default settings for yacc and lex
## should work.
##
## The m4 distributed with FreeBSD does not accept the -B flag. See README
## for details.

# MACHINE=FreeBSD
# OS=BSD

# XINCLUDE=-I/usr/X11R6/include
# XLIB=/usr/X11R6/lib

# CC=cc
# CPP=/usr/libexec/cpp -P
# CFLAGS=-O2 -D__NO_MATH_INLINES

# LD=ld
# LDFLAGS=

# RANLIB=ranlib
# AR=ar

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= $(LEXLIB) -lm

# TERMCAP=-ltermcap
# TERMOPT=-DTERMIO

## end	FreeBSD


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	HP running HPUX (versions unknown)
# Compiler:	HP C compiler
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

## The GENESIS maintainers have very little experience with HPUX and the
## status of this configuration is unknown.  There have been reports of
## display problems under HPUX. 

# MACHINE=hpux
# OS=SYSV

# XINCLUDE=-I/usr/include/X11R5
# XLIB=/usr/lib/X11R5

# CC=cc
# CPP=/lib/cpp -P
# CFLAGS=-O
# LD=ld
# LDFLAGS=

# RANLIB=ranlib
# AR=ar

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= $(LEXLIB) -lm

# TERMCAP =
# TERMOPT =	-DPLAINTERM

# end	HP running HPUX (versions unknown)


# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	IBM AIX 4.x
# Compiler:	IBM 'xlc' C compiler version 5
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
#
# This combination of flags has been tested on IBM RS/6000 computers
# running AIX 4.2 and 4.3, as well as the teraflop-scale Blue Horizon
# Power3 system at SDSC.  We thank Chuck Charman and Giri Chukkpalli
# for their help.

# MACHINE = aix
# OS = SYSV

# XINCLUDE = -I/usr/include
# XLIB = /usr/lib

# CC = xlc
# CPP = /lib/cpp -P
##
## If you are using an IBM Power3 system, such as the Teraflops, add the
## following to CFLAGS for better optimization:   -qarch=pwr3 -qtune=pwr3
##
# CFLAGS = -DBIGENDIAN -U__STR__ -ma -O2 -qchars=signed -qmaxmem=8192
# LD = ld
# LDFLAGS =

# RANLIB = ranlib
# AR = ar

# YACC = yacc
# LEX = lex
# LEXLIB = -ll -lcurses -lcur
# LIBS = $(LEXLIB)  -lm -lrs2 -lbsd -lc

# TERMCAP = -lcurses -lcur
# TERMOPT = -DDONT_USE_SIGIO

# end	IBM RS6000 running AIX

# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	Cygwin
# Compiler:	gcc
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

##
## Please note that all files should have Unix-like line terminators.
## If you get "syntax error"s from code_g or code_sys during compilation,
## it may be the result of incorrect line terminators. Offending files can
## be fixed using the dos2unix command.
##

#MACHINE=Cygwin

#OS=SYSV

#XINCLUDE=-I/usr/include
#XLIB=/usr/X11R6/lib

#CC=gcc
#CPP=cpp -P
#CFLAGS=-O2
#LD=ld
#LDFLAGS=

#RANLIB=ranlib
#AR=ar

#YACC=bison -y
#LEX=flex -l
#LEXLIB=-lfl
#LIBS= $(LEXLIB) -lm

#TERMCAP=-lncurses
#TERMOPT=-DTERMIO -DDONT_USE_SIGIO

#export CODE_G_LFLAGS=-Wl,--stack,0x400000
#export EXE_EXT=.exe

# end	CygWin

# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~
# System:	Other UNIX system
# Compiler:	Other compiler
# ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~  ~

# Other UNIX systems
#
# Settings are general and the underlying makefile tries to set certain
# system dependent macros to something which will work everywhere.
#
# Note: you'll have to at least set the OS macro to either SYSV or
#       BSD to indicate either a System V or a Berkeley variant OS
#       respectively.  Also probably need to set RANLIB to echo if
#       there is no ranlib command on your system.
#

# MACHINE=other

# !!! OS must be set properly !!!  Uncomment *one* of the following.

# OS=SYSV
# OS=BSD

# XINCLUDE=-I/usr/include
# XLIB=/usr/lib

# CC=cc
# CPP=/lib/cpp -P
# CFLAGS=-O
# LD=ld
# LDFLAGS=

# RANLIB=ranlib
# AR=ar

# YACC=yacc
# LEX=lex
# LEXLIB=-ll
# LIBS= $(LEXLIB) -lm

# TERMCAP =
# TERMOPT =	-DDONT_USE_SIGIO

# end	System specific suggested settings


# ----------------------------------------------------------------------
# E. CUSTOM SETTINGS
#
# Here is the place to overide macro settings from above selectively.
# You should uncomment one of the above sections and uncomment items in
# this section to override the standard settings.
# ----------------------------------------------------------------------

## This is one of SYSV for System V UNIX varients and BSD for Berkeley
## vartients.

# OS =		BSD


##
## X11 settings
##

## Typical settings:

# XLIB	=	/usr/lib
# XINCLUDE =	-I.

## For some versions of XFree86 (PC's with Linux) XLIB will need to be
## set as follows

# XLIB	=	/usr/X11/lib


## For SUN OpenWindows:
#
# XLIB	=	/usr/openwin/lib
# XINCLUDE =	-I/usr/openwin/include
#

## Typically /tmp but can be changed if there's not enough space there.
# TMPDIR = /tmp

##
## C compiler
##

## Typical settings:
#
# CC=cc
# CPP=/lib/cpp -P
# CFLAGS=-O
# LD=ld

## GCC C compiler:
##
## For gcc, usually there will be a link from /lib/cpp to wherever cpp
## is installed.  If not, try to find the gcc-lib installation, perhaps
## under /usr/lib/gcc-lib and either create a symlink from /lib/cpp or
## change the CPP define below to use the full path to where cpp lives.
##
## Later versions of gcc compile GENESIS (with many warnings) without
## using the -traditional option.  If the compile fails you might try
## adding -traditional to CFLAGS or updating your compiler.

# CC=gcc
# CPP=/lib/cpp -P
# CFLAGS=-O
# LD=ld


##
## LDFLAGS are the final link options
##

# LDFLAGS=


##
## RANLIB
##

## Set the RANLIB macro to "RANLIB = echo" on systems without ranlib.
## (Only important to set for MACHINE=other and perhaps Linux; all other
##  MACHINEs will ignore the value set here.)
##
## AR is the library archive program used to build the Xodus widget
## libraries

# RANLIB=ranlib
# AR=ar


##
## YACC and LEX options.
##

# YACC=yacc
# LEX=lex
# LEXLIB=-ll

## If you have GNU bison and flex uncomment the following lines.
##
## YACC=bison -y
## LEX=flex -l
## LEXLIB=-lfl
##
## Solaris 2.4 users note: the yacc for Solaris 2.4 produces an
## bad parse table which causes the parser to fail.  Please use
## bison/flex.
##
## Linux users note: use flex and bison rather than yacc and lex.
## lex and yacc are scripts which use bison and flex on some systems
## while others have an independent yacc in addition to bison.
## The independent yacc output will fail to compile.
##
## SGI user note: the SGI lex defines a relatively small token text
## buffer of 200 characters.  Lex will exit if a token's text exceeds
## this limit (e.g. a very long command argument like shape coords
## lists).  Changes have been made to avoid this problem.  If you
## encounter it anyway then using flex will fix it.
##
## Other users: if you don't have bison, flex, yacc or lex, see the
## section in src/README about getting bison and flex or using the
## preprocessed yacc and lex output.


##
## LIBS the link libraries (not including X11)
##

# LIBS 	= 	$(LEXLIB) -lm


# ----------------------------------------------------------------------
# F. BEGINNING OF NON-CONFIGURABLE DEFINITIONS
#
# This end the user configurable part of the Makefile.  You shouldn't
# have to change things below this point.
# ----------------------------------------------------------------------

INSTALLBIN     = $(INSTALLDIR)/bin

#
# X11 libraries
#

XLIBS =		-L$(XLIB) \
		-lXt \
		-lX11

RCSRELEASE =	DR2-2-P1
MF = 		Makefile.$(MACHINE)
SHELL = 	/bin/sh

SIMLIB	=	../lib

XODUSLIB = 	Xodus

INTERP =	ss/ss.o shell/shelllib.o

MODELCONTAINER = neurospaces/neurospaceslib.o

BASECODE =	sim/simlib.o sys/utillib.o $(INTERP) par/parlib.o $(MODELCONTAINER)




XOBJLIBS =	buffer/buflib.o \
		segment/seglib.o \
		hh/hhlib.o \
		device/devlib.o \
		out/outlib.o \
		olf/olflib.o \
		tools/toollib.o \
		concen/conclib.o \
		hines/hineslib.o \
		user/userlib.o \
		param/paramlib.o \
		pore/porelib.o \
		$(OLDCONNOBJ) \
		$(DISKIOOBJ) \
		$(KINETICSOBJ) \
		newconn/newconnlib.o

XODUS 	=	$(XODUSLIB)/_xo/xolib.o \
		$(XODUSLIB)/_widg/widglib.o \
		$(XODUSLIB)/_draw/drawlib.o \
		$(XODUSLIB)/Draw/libDraw.a \
		$(XODUSLIB)/Widg/libWidg.a \
		$(XODUSLIB)/Xo/libXo.a

EXTRALIBS =     $(TERMCAP)

XSUBDIR =        sys ss sim $(SPRNGDIR) shell newconn $(OLDCONNDIR) \
		buffer concen device hh hines olf out segment \
                tools user param pore convert $(DISKIODIR) \
                $(KINETICSDIR) Xodus par

SUBDIR = 	sys ss shell par neurospaces


NXSUBDIR =	sys ss shell sim $(SPRNGDIR) newconn oldconn \
		buffer concen device hh hines olf out segment \
                tools user param pore convert $(DISKIODIR) \
		$(KINETICSDIR) par

MINSUBDIR =	sys ss shell sim par neurospaces

LIBLIST = neurospaces

XLIBLIST =	output \
		hh \
		devices \
		buffer \
		segment \
		user \
		xo \
		draw \
		widg \
		olf \
		tools \
		concen \
		hines \
		param \
		pore \
		newconn \
		$(DISKIOLIB) \
		$(OLDCONNLIB) \
		$(KINETICSLIB)

NXLIBLIST = 	output \
		hh \
		devices \
		buffer \
		segment \
		user \
		olf \
		tools \
		concen \
		hines \
		param \
		pore \
		newconn \
		$(DISKIOLIB) \
		$(OLDCONNLIB) \
		$(KINETICSLIB)

#
# all is now the default target
#

all: code_g default

genesis: all

#
# Remove kinlib.o and text.o in case the last thing made was nxgenesis.
#
default: liblist
	@rm -f kinetics/text.o kinetics/kinlib.o
	@make -f $(MF) CC="$(CC)" TMPDIR="$(TMPDIR)" LD="$(LD)" AR="$(AR)" RANLIB="$(RANLIB)" CPP="$(CPP)" YACC="$(YACC)" LEX="$(LEX)" LEXLIB="$(LEXLIB)" OS="$(OS)" MACHINE="$(MACHINE)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" CFLAGS_IN="$(CFLAGS) $(DISKIOFLAGS) $(SPRNG_FLAG)" IRIX_HACK="$(IRIX_HACK)" LDFLAGS="$(LDFLAGS)" SPRNG_LIB="$(SPRNG_LIB)" XLIBS="$(XLIBS)" XINCLUDE="$(XINCLUDE)" LIBS="$(LIBS)" TERMCAP="$(TERMCAP)" TERMOPT="$(TERMOPT)" MF="$(MF)" SUBDIR="$(SUBDIR)" DISKIOSUBDIR="$(DISKIOSUBDIR)" BASECODE="$(BASECODE)" OBJLIBS="$(OBJLIBS)" EXTRALIBS="$(EXTRALIBS)" XODUS="$(XODUS)"  libs genesis

#
# Remove kinlib.o and text.o in case the last thing made had X11 stuff.
#
nxdefault: nxliblist
	@rm -f kinetics/text.o kinetics/kinlib.o
	@make -f $(MF) CC="$(CC)" TMPDIR="$(TMPDIR)" LD="$(LD)" AR="$(AR)" RANLIB="$(RANLIB)" CPP="$(CPP)" YACC="$(YACC)" LEX="$(LEX)" LEXLIB="$(LEXLIB)" OS="$(OS)" MACHINE="$(MACHINE)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" CFLAGS_IN="$(CFLAGS) $(DISKIOFLAGS) $(SPRNG_FLAG) -DNO_X" IRIX_HACK="$(IRIX_HACK)" LDFLAGS="$(LDFLAGS)" SPRNG_LIB="$(SPRNG_LIB)" LIBS="$(LIBS)" MF="$(MF)" TERMCAP="$(TERMCAP)" TERMOPT="$(TERMOPT)" SUBDIR="$(SUBDIR)" NXSUBDIR="$(NXSUBDIR)" MINSUBDIR="$(MINSUBDIR)" DISKIOSUBDIR="$(DISKIOSUBDIR)" BASECODE="$(BASECODE)" OBJLIBS="$(OBJLIBS)" EXTRALIBS="$(EXTRALIBS)" nxlibs nxgenesis

mindefault: minliblist
	@make -f $(MF) CC="$(CC)" TMPDIR="$(TMPDIR)" LD="$(LD)" AR="$(AR)" RANLIB="$(RANLIB)" CPP="$(CPP)" YACC="$(YACC)" LEX="$(LEX)" LEXLIB="$(LEXLIB)" OS="$(OS)" MACHINE="$(MACHINE)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" CFLAGS_IN="$(CFLAGS) $(SPRNG_FLAG)" IRIX_HACK="$(IRIX_HACK)" LDFLAGS="$(LDFLAGS)" SPRNG_LIB="$(SPRNG_LIB)" LIBS="$(LIBS)" MF="$(MF)" TERMCAP="$(TERMCAP)" TERMOPT="$(TERMOPT)" SUBDIR="$(SUBDIR)" NXSUBDIR="$(NXSUBDIR)" MINSUBDIR="$(MINSUBDIR)" BASECODE="$(BASECODE)" OBJLIBS="$(OBJLIBS)" EXTRALIBS="$(EXTRALIBS)" minlibs mingenesis

code_g:
	@make -f $(MF) CC="$(CC)" TMPDIR="$(TMPDIR)" LD="$(LD)" CPP="$(CPP)" YACC="$(YACC)" LEX="$(LEX)" LEXLIB="$(LEXLIB)" OS="$(OS)" MACHINE="$(MACHINE)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" CFLAGS_IN="$(CFLAGS)" IRIX_HACK="$(IRIX_HACK)" LDFLAGS="$(LDFLAGS)" LIBS="$(LIBS)" MF="$(MF)" TERMCAP="$(TERMCAP)" TERMOPT="$(TERMOPT)" SUBDIR="$(SUBDIR)" NXSUBDIR="$(NXSUBDIR)" MINSUBDIR="$(MINSUBDIR)" BASECODE="$(BASECODE)" OBJLIBS="$(OBJLIBS)" EXTRALIBS="$(EXTRALIBS)" code_g

nxgenesis: code_g nxdefault
nxall: code_g nxdefault

mingenesis: code_g mindefault
minall: code_g mindefault

liblist: Makefile
	@echo "# liblist - This file is generated automatically." > liblist
	@echo "#           DO NOT EDIT unless you are sure you" >> liblist
	@echo "#           know what you are doing.  Generally" >> liblist
	@echo "#           Makefile should be edited instead." >> liblist
	@echo $(LIBLIST) | tr ' ' '\012' >> liblist

nxliblist: Makefile
	@echo "# nxliblist - This file is generated automatically." > nxliblist
	@echo "#             DO NOT EDIT unless you are sure you" >> nxliblist
	@echo "#             know what you are doing.  Generally" >> nxliblist
	@echo "#             Makefile should be edited instead." >> nxliblist
	@echo $(NXLIBLIST) | tr ' ' '\012' >> nxliblist

minliblist: Makefile
	@echo "# minliblist - This file is generated automatically." > minliblist
	@echo "#              DO NOT EDIT unless you are sure you" >> minliblist
	@echo "#              know what you are doing.  Generally" >> minliblist
	@echo "#              Makefile should be edited instead." >> minliblist

cleandist: clean
	-(mv Makefile Makefile.bak)
	-(rm -rf $(INSTALLDIR)/bin)
	-(rm -f  $(INSTALLDIR)/Libmake)
	-(rm -f  $(INSTALLDIR)/Usermake)
	-(rm -rf $(INSTALLDIR)/startup/*)
	-(rm -rf $(INSTALLDIR)/startup/.*simrc)
	-(rm -rf $(INSTALLDIR)/startup)
	-(rm -rf $(INSTALLDIR)/lib/*)
	-(rm -rf $(INSTALLDIR)/lib)
	-(rm -rf $(INSTALLDIR)/include/*)
	-(rm -rf $(INSTALLDIR)/include)
	-(rm -f  $(INSTALLDIR)/genesis)
	-(rm -f  $(INSTALLDIR)/nxgenesis)
	-(rm -f  $(INSTALLDIR)/mingenesis)
	-(rm -rf $(INSTALLDIR)/.*simrc)
	-(rm -rf $(INSTALLDIR)/man/man1)
	-(rm -f  $(INSTALLBIN)/convert)
	-(rm -f  liblist nxliblist minliblist)
	-(rm -f  make.out nxmake.out minmake.out)
	-(rm -f  install.out nxinstall.out mininstall.out)
	-(rm -rf ../distributions)
	-(rm -f TAGS)
	-(find . -name '*~' -exec rm -f {} ';')
	@echo "Done with full clean"


clean:
	@make -f $(MF) MF="$(MF)" DISKIOSUBDIR="$(DISKIOSUBDIR)" SUBDIR="$(SUBDIR)"  SPRNG_LIB="$(SPRNG_LIB)" clean
	-(rm -f  liblist nxliblist minliblist)

rcsclean:
	@make -f $(MF) MF="$(MF)" SUBDIR="$(SUBDIR)"  rcsclean

makedirs:
	-@mkdir -p $(INSTALLDIR)
	-@mkdir -p $(INSTALLBIN)
	-@mkdir -p $(INSTALLDIR)/Doc
	-@mkdir -p $(INSTALLDIR)/Hyperdoc
	-@mkdir -p $(INSTALLDIR)/Scripts
	-@mkdir -p $(INSTALLDIR)/Tutorials
	-@mkdir -p $(INSTALLDIR)/lib
	-@mkdir -p $(INSTALLDIR)/include
	-@mkdir -p $(INSTALLDIR)/startup
	-@mkdir -p $(INSTALLDIR)/src

tags:
	etags `find . /usr/include/X11/ -name '*.[chg]' ! -name '*@*'`
	etags -a `find /usr/include -name '*.h'`

install: makedirs
	@make -f $(MF) MF="$(MF)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" DISKIOSUBDIR="$(DISKIOSUBDIR)" SPRNG_LIB="$(SPRNG_LIB)" SUBDIR="$(SUBDIR)" RANLIB="$(RANLIB)" install

nxinstall: makedirs
	@make -f $(MF) MF="$(MF)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" DISKIOSUBDIR="$(DISKIOSUBDIR)" SPRNG_LIB="$(SPRNG_LIB)" NXSUBDIR="$(NXSUBDIR)" RANLIB="$(RANLIB)" nxinstall

mininstall: makedirs
	@make -f $(MF) MF="$(MF)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" SPRNG_LIB="$(SPRNG_LIB)" MINSUBDIR="$(MINSUBDIR)" RANLIB="$(RANLIB)" mininstall

VERSNAME="genesis-2.3"
bindist: genesis nxgenesis
	make INSTALLDIR="`pwd`/../distributions/$(VERSNAME)/genesis" install
	cp nxgenesis "../distributions/$(VERSNAME)/genesis"
	(cd ..; \
	cp AUTHORS CONTACTING.GENESIS COPYRIGHT GPLicense LGPLicense \
		README README.bindist binsetup "distributions/$(VERSNAME)/genesis";)
	(cd ../distributions; \
	cp $(VERSNAME)/genesis/src/startup/*simrc $(VERSNAME)/genesis/startup;\
	rm -f $(VERSNAME)/genesis/startup/\.*simrc;\
	rm -rf $(VERSNAME)/genesis/src; \
	tar czf $(VERSNAME)-$(MACHINE)-bin.tar.gz -X ../src/excludeFromBinary $(VERSNAME);\
	tar cjf $(VERSNAME)-$(MACHINE)-bin.tar.bz2 -X ../src/excludeFromBinary $(VERSNAME);\
	rm -rf $(VERSNAME))

#
# make separate source dists for genesis and pgenesis.
# cvs export must be used so that empty directories are pruned.
#
srcdist: 
	-@mkdir -p ../distributions
	(CVSROOT=$(USER)@cvs.sf.net:/cvsroot/genesis-sim; \
	CVS_RSH=ssh; \
	cd ../distributions; \
	cvs export -D now genesis2 > /dev/null; \
	mv genesis2 $(VERSNAME); \
	tar cZf $(VERSNAME)-src.tar.Z -X ../src/excludeFromSrc $(VERSNAME)/genesis; \
	md5sum $(VERSNAME)-src.tar.Z > $(VERSNAME)-src.tar.Z.md5; \
	tar czf $(VERSNAME)-src.tar.gz -X ../src/excludeFromSrc $(VERSNAME)/genesis; \
	md5sum $(VERSNAME)-src.tar.gz > $(VERSNAME)-src.tar.gz.md5; \
	tar cjf $(VERSNAME)-src.tar.bz2 -X ../src/excludeFromSrc $(VERSNAME)/genesis; \
	md5sum $(VERSNAME)-src.tar.bz2 > $(VERSNAME)-src.tar.bz2.md5; \
	tar cZf p$(VERSNAME)-src.tar.Z -X ../src/excludeFromSrc $(VERSNAME)/pgenesis; \
	md5sum p$(VERSNAME)-src.tar.Z > p$(VERSNAME)-src.tar.Z.md5; \
	tar czf p$(VERSNAME)-src.tar.gz -X ../src/excludeFromSrc $(VERSNAME)/pgenesis; \
	md5sum p$(VERSNAME)-src.tar.gz > p$(VERSNAME)-src.tar.gz.md5; \
	tar cjf p$(VERSNAME)-src.tar.bz2 -X ../src/excludeFromSrc $(VERSNAME)/pgenesis; \
	md5sum p$(VERSNAME)-src.tar.bz2 > p$(VERSNAME)-src.tar.bz2.md5; \
	rm -rf $(VERSNAME))
	-cp README ../distributions/README.$(VERSNAME)
	-cp ChangeLog ../distributions/ChangeLog.$(VERSNAME)

TestSuite:
	(cd ..; \
		tar czf TestSuite.tar.gz --exclude CVS TestSuite; \
		tar cjf TestSuite.tar.bz2 --exclude CVS TestSuite)



