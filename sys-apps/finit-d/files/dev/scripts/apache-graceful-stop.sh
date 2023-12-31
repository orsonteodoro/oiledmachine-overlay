#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Modified script from www-servers/apache package
# Initscript tarball:  https://dev.gentoo.org/~graaff/dist/apache/
# A graceful stop advises the children to exit after the current request and stops the server.

source /etc/finit.d/scripts/lib.sh
source /etc/finit.d/scripts/apache-lib.sh

gracefulstop() {
	checkconfig || return 1
	ebegin "Gracefully stopping apache"
	${APACHE2} ${APACHE2_OPTS} -k graceful-stop
	eend $?
}

gracefulstop
