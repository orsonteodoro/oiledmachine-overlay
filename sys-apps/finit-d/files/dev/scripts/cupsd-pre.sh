#/bin/sh
# =net-print/cups-2.4.7-r1::gentoo

source /etc/finit.d/scripts/lib.sh

start_pre() {
	get_ready_dir "0755" "root:lp" "/run/cups"
	get_ready_dir "0511" "lp:lpadmin" "/run/cups/certs" &
	get_ready_dir "0775" "root:lp" "/var/cache/cups"
	get_ready_dir "0775" "root:lp" "/var/cache/cups/rss" &
}

start_pre
