#!/bin/sh
# =net-irc/znc-1.8.2-r2:0/1.8.2::gentoo
source /etc/finit.d/scripts/lib.sh

start_pre() {
	get_ready_dir "0770" "znc:znc" "/run/znc"
}

start_pre
