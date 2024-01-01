#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

source /etc/finit.d/scripts/inspircd-lib.sh

rehash() {
	ebegin "Rehashing InspIRCd"
	kill -SIGHUP $(cat "${pidfile}")
	eend $?
}

rehash
