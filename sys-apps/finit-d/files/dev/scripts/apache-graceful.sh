#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from https://dev.gentoo.org/~graaff/dist/apache/
# A graceful restart advises the children to exit after the current request and reloads the configuration.

source /etc/finit.d/scripts/apache-lib.sh

graceful() {
	checkconfig || return 1
	ebegin "Gracefully restarting apache"
	${APACHE2} ${APACHE2_OPTS} -k graceful
	eend $?
}

graceful
