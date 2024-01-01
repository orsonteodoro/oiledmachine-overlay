#!/bin/bash
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Script from https://gitweb.gentoo.org/repo/gentoo.git/tree/sys-power/cpupower

source /etc/finit.d/scripts/cpupower-lib.sh

start() {
	change "${START_OPTS}"
}

start
