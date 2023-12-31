#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Modified script from www-servers/apache package
# Initscript tarball:  https://dev.gentoo.org/~graaff/dist/apache/
# Gives the full status of the server. Requires lynx and server-status to be enabled.

source /etc/finit.d/scripts/lib.sh
source /etc/finit.d/scripts/apache-lib.sh

fullstatus() {
	if ! command -v $(set -- ${LYNX}; echo $1) 2>&1 >/dev/null ; then
		eerror "lynx not found! you need to emerge www-client/lynx"
	else
		${LYNX} ${STATUSURL}
	fi
}

fullstatus
