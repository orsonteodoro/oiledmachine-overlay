#!/bin/sh
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original script obtained from https://gitweb.gentoo.org/repo/gentoo.git/tree/www-servers/varnish

source /etc/finit.d/scripts/varnishncsa-lib.sh

reload() {
	flush
	rotate
}

reload
