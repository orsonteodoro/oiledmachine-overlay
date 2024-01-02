#/bin/sh
# =net-print/cups-2.4.7-r1::gentoo

source /etc/finit.d/scripts/lib.sh

pidfile="/run/cupsd.pid"

start_pre() {
	get_ready_dir "0755" "root:lp" "/run/cups"
	get_ready_dir "0511" "lp:lpadmin" "/run/cups/certs" &
	get_ready_dir "0775" "root:lp" "/var/cache/cups"
	get_ready_dir "0775" "root:lp" "/var/cache/cups/rss" &
}

start() {
	cupsd -f -c /etc/cups/cupsd.conf -s /etc/cups/cups-files.conf
}

start_pre
start
