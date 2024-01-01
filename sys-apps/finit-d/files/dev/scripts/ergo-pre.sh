#!/bin/sh
source /etc/finit.d/scripts/lib.sh

start_pre() {
	get_ready_file "0640" "ergo:ergo" "/var/log/ergo.out" &
	get_ready_file "0640" "ergo:ergo" "/var/log/ergo.err"
}

start_pre
