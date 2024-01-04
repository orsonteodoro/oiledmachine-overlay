#!/bin/sh

. /etc/finit.d/scripts/lib.sh

start_pre() {
	checkpath "f" "ergo:ergo" "0640" "/var/log/ergo.out" &
	checkpath "f" "ergo:ergo" "0640" "/var/log/ergo.err"
}

start_pre
