#! /bin/sh

aclocal \
&& autoconf \
&& autoheader \
&& automake -a --foreign

./configure CFLAGS='-g -O0'
