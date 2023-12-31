#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Modified script from www-servers/apache package
# Initscript tarball:  https://dev.gentoo.org/~graaff/dist/apache/
# Run syntax tests for configuration files.

source /etc/finit.d/scripts/lib.sh
source /etc/finit.d/scripts/apache-lib.sh

configtest() {
	ebegin "Checking ${SVCNAME} configuration"
	checkconfig
	eend $?
}

configtest
