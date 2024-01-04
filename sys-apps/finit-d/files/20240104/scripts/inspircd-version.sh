#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

. /etc/finit.d/scripts/inspircd-lib.sh

version() {
	ebegin "Retrieve InspIRCd version"
	"${command}" --version
	eend $?
}

version
