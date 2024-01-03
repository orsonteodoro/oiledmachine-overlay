#!/bin/sh
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/varnish

. /etc/finit.d/scripts/varnishd-lib.sh

reload() {
	checkconfig || return 1

	ebegin "Reloading varnish"

	$VARNISHADM vcl.list >/dev/null 2>&1
	ret=$?
	if [ $ret -ne 0 ]; then
		eerror "${SVCNAME} cannot list configuration"
		return 1
	fi

	new_config="reload_$(date +%FT%H:%M:%S)"
	$VARNISHADM vcl.load $new_config $CONFIGFILE >/dev/null 2>&1
	ret=$?
	if [ $ret -ne 0 ]; then
		eerror "${SVCNAME} cannot load configuration"
		return 1
	fi

	$VARNISHADM vcl.use $new_config >/dev/null 2>&1
	ret=$?
	if [ $ret -ne 0 ]; then
		eerror "${SVCNAME} cannot switch configuration"
		return 1
	fi

	eend 0
}

reload
