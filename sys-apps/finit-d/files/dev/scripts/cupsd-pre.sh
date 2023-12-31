#/bin/bash
source /etc/finit.d/scripts/lib.sh
get_ready_dir "0755" "root:lp" "/run/cups"
get_ready_dir "0511" "lp:lpadmin" "/run/cups/certs" &
get_ready_dir "0775" "root:lp" "/var/cache/cups"
get_ready_dir "0775" "root:lp" "/var/cache/cups/rss" &
