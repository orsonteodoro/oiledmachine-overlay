#!/bin/sh
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

source /etc/finit.d/scripts/inspircd-lib.sh

start_pre() {
	checkpath "d" "inspircd:inspircd" "0750" "/run/inspircd/"
}

start() {
	declare -a "args=(${command_args})"
	"${command}" "${args[@]}"
}

start_pre
start
