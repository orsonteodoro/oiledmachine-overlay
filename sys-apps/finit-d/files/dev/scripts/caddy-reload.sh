#!/bin/sh
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

. /etc/finit.d/scripts/caddy-lib.sh

reload() {
    if ! service_started "${SVCNAME}" ; then
        eerror "${SVCNAME} isn't running"
        return 1
    fi
    checkconfig || { eerror "Invalid configuration file !" && return 1; }

    ebegin "Reloading ${SVCNAME}"
    "${command}" "reload" --force --config "${caddy_config}" > /dev/null 2>&1
    eend $?
}

reload
