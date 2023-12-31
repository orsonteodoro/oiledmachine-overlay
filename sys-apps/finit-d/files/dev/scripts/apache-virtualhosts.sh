#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Modified script from www-servers/apache package
# Initscript tarball:  https://dev.gentoo.org/~graaff/dist/apache/
# Show the settings as parsed from the config file (currently only shows the virtualhost settings).

source /etc/finit.d/scripts/lib.sh
source /etc/finit.d/scripts/apache-lib.sh

virtualhosts() {
	checkconfig || return 1
	${APACHE2} ${APACHE2_OPTS} -S
}

virtualhosts
