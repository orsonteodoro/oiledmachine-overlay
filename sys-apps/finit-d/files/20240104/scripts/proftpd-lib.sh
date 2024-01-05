#!/bin/sh
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original script from https://gitweb.gentoo.org/repo/gentoo.git/tree/net-ftp/proftpd

. /etc/finit.d/scripts/lib.sh

check_configuration() {
	if [ ! -e "/etc/proftpd/proftpd.conf" ] ; then
		eerror "To execute the ProFTPD server you need a /etc/proftpd/proftpd.conf configuration"
		eerror "file. In /etc/proftpd you can find a sample configuration."
		return 1
	fi
	"/usr/sbin/proftpd" -t >/dev/null 2>&1
	if [ $? -ne 0 ] ; then
		eerror "The ProFTPD configuration file /etc/proftpd/proftpd.conf is invalid! You have to"
		eerror "fix your configuration in order to run the ProFTPD server. For more information"
		eerror "you may execute the ProFTPD configuration check '/usr/sbin/proftpd -t'."
		return 2
	fi
}
