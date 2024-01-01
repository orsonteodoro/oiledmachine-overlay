#!/bin/sh
source /etc/finit.d/scripts/lib.sh

start_pre() {
	get_ready_dir "0770" "znc:znc" "/run/znc"
}

start_pre
