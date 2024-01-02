#/bin/sh
# =net-print/cups-2.4.7-r1::gentoo

source /etc/finit.d/scripts/lib.sh

pidfile="/run/cupsd.pid"

start_pre() {
	checkpath "d" "root:lp"    "0755" "/run/cups"
	checkpath "d" "lp:lpadmin" "0511" "/run/cups/certs" &
	checkpath "d" "root:lp"    "0775" "/var/cache/cups"
	checkpath "d" "root:lp"    "0775" "/var/cache/cups/rss" &
}

start() {
	cupsd -f -c /etc/cups/cupsd.conf -s /etc/cups/cups-files.conf
}

start_pre
start
