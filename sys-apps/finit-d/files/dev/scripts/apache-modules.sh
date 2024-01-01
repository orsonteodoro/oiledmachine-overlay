#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script from tarball:  https://dev.gentoo.org/~graaff/dist/apache/
# Dump a list of loaded Static and Shared Modules.

modules() {
	checkconfig || return 1
	${APACHE2} ${APACHE2_OPTS} -M 2>&1
}

modules
