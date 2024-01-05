#!/bin/sh
# =net-p2p/bitcoin-core-25.1-r1::gentoo

. /etc/conf.d/bitcoind
. /etc/finit.d/scripts/lib.sh

SVCNAME=${SVCNAME:-"bitcoind"}

: ${BITCOIND_CONFIGFILE:="/etc/bitcoin/bitcoin.conf"}
: ${BITCOIND_PIDDIR:="/run/bitcoind"}
: ${BITCOIND_PIDFILE:="${BITCOIND_PIDDIR}/${SVCNAME}.pid"}
: ${BITCOIND_DATADIR:="/var/lib/bitcoind"}
: ${BITCOIND_LOGDIR:="/var/log/bitcoind"}
: ${BITCOIND_USER:=${BITCOIN_USER:-"bitcoin"}}
: ${BITCOIND_GROUP:="bitcoin"}
: ${BITCOIND_BIN:="/usr/bin/bitcoind"}
: ${BITCOIND_NICE:=${NICELEVEL:-0}}
: ${BITCOIND_OPTS=${BITCOIN_OPTS}}

checkconfig() {
	if grep -qs '^rpcuser=' "${BITCOIND_CONFIGFILE}" &&
		! grep -qs '^rpcpassword=' "${BITCOIND_CONFIGFILE}"
	then
		eerror ""
		eerror "ERROR: You must set a secure rpcpassword to run bitcoind."
		eerror "The setting must appear in ${BITCOIND_CONFIGFILE}"
		eerror ""
		eerror "This password is security critical to securing wallets "
		eerror "and must not be the same as the rpcuser setting."
		eerror "You can generate a suitable random password using the following "
		eerror "command from the shell:"
		eerror ""
		eerror "bash -c 'tr -dc a-zA-Z0-9 < /dev/urandom | head -c32 && echo'"
		eerror ""
		eerror "It is recommended that you also set alertnotify so you are "
		eerror "notified of problems:"
		eerror ""
		eerror "ie: alertnotify=echo %%s | mail -s \"Bitcoin Alert\"" \
			"admin@foo.com"
		eerror ""
		return 1
	fi
}
