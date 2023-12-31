#!/bin/bash
source /etc/finit.d/scripts/lib.sh
get_ready_file "0640" "ergo:ergo" "/var/log/ergo.out" &
get_ready_file "0640" "ergo:ergo" "/var/log/ergo.err"
