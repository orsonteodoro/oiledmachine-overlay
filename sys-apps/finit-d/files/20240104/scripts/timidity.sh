#!/bin/sh
. /etc/conf.d/timidity
. /etc/finit.d/scripts/lib.sh

start() {
	ebegin "Starting TiMidity++ Virtual Midi Sequencer"
	test -n "$TIMIDITY_PCM_NAME" && export TIMIDITY_PCM_NAME
	set -- -iA ${TIMIDITY_OPTS}
	cd "/usr/share/timidity"
	exec "/usr/bin/timidity" "$@"
	eend $?
}

start
