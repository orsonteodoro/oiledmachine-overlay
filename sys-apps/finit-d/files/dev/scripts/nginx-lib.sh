#!/bin/bash
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Sampled from nginx.initd-r4 from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/nginx/files

source /etc/conf.d/nginx
source /etc/finit.d/scripts/lib.sh

configtest() {
	ebegin "Checking nginx' configuration"
	nginx -c /etc/nginx/nginx.conf -t -q

	if (( $? -ne 0 )) ; then
		nginx -c /etc/nginx/nginx.conf -t
	fi

	eend $? "failed, please correct errors above"
}
