#!/usr/bin/env make
#
# rpl - replace strings in files
#
# Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby granted,
# provided that the above copyright, this permission notice and text
# this comment, and the disclaimer below appear in all of the following:
#
#       supporting documentation
#       source copies
#       source works derived from this source
#       binaries derived from this source or from derived source
#
# LANDON CURT NOLL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
# EVENT SHALL LANDON CURT NOLL BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
# USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
#
# Share and enjoy! :-)


SHELL= bash

CC= cc
RM= rm
CP= cp
CHMOD= chmod
INSTALL= install
MAN1DIR= /usr/local/man/man1
MKDIR= mkdir
PYTHON= python

DESTDIR= /usr/local/bin

SRC_KCOYNER= rpl-kcoyner/README.md rpl-kcoyner/rpl rpl-kcoyner/rpl.1 rpl-kcoyner/setup.py
SRC_RPL= rpl-rrthoman/rpl
SRC_USED= src/README.md src/rpl src/rpl.1 src/setup.py

TARGETS= src/rpl

all: src-merge

# rules, not file targets
#
.PHONY: all configure clean clobber install src-merge

src-merge: rpl-kcoyner rpl-rrthoman ${SRC_KCOYNER} ${SRC_RPL}
	${MKDIR} -p src
	${CP} -v -f ${SRC_KCOYNER} src
	${CP} -v -f ${SRC_RPL} src

src/rpl: src-merge
	cd src; ${PYTHON} setup.py build

rpl-kcoyner:
	git clone git@github.com:kcoyner/rpl.git $@

rpl-rrthoman:
	git clone git@github.com:rrthomas/rpl.git $@

configure: rpl-kcoyner rpl-rrthoman

clean:

clobber: clean
	${RM} -rf src

install: all ${SRC_USED}
	cd src; ${PYTHON} setup.py install
	${INSTALL} -c -m 0444 src/rpl.1 ${MAN1DIR}

distclean: clobber
	${RM} -rf rpl-kcoyner rpl-rrthoman
