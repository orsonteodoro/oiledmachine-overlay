# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SRC_URI=""
S="${WORKDIR}"

DESCRIPTION="finit.d/*.conf files for the finit init system"
HOMEPAGE="
https://troglobit.com/projects/finit/
https://github.com/troglobit/finit
"
LICENSE="
	MIT
	GPL-2
"
#KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
RESTRICT="mirror test"
SLOT="0"
SERVICES=(
	acpid
	actkbd
	apache
	apparmor
	anacron
	avahi-daemon
	avahi-dnsconfd
	bitcoind
	bitlbee
	bluez
	consolefont
	containerd
	coolercontrol
	cpupower
	cups-browsed
	cupsd
	cron
	dhcpcd
	distccd
	dmeventd
	docker
	dropbear
	elogind
	fancontrol
	getty
	git
	hdparm
	hostname
	icecast
	inspircd
	iperf3
	iptables
	ip6tables
	iwd
	keepalived
	keymap
	laptop_mode
	lightdm
	lm_sensors
	lxdm
	modules
	mysql
	networkmanager
	nginx
	openvpn
	redis
	redis-sentinel
	rsyncd
	rtkit
	ntpd
	plymouth
	proftpd
	pure-ftpd
	pure-uploadscript
	pydoc
	rp-pppoe
	rsyslogd
	seatd
	sntpd
	spacenavd
	squid
	sshd
	syslogd
	svnserve
	thermald
	tor
	twistd
	uuidd
	varnishd
	varnishlog
	varnishncsa
	vsftpd
	watchdog
	wg-quick
	xdm
	znc
)
IUSE+="
	${SERVICES[@]}
	dash
	hook-scripts
	netlink
"
NEEDS_NETWORK="
	apache
	bitcoind
	coolercontrol
	distccd
	icecast
	nginx
	ntpd
	openvpn
	proftpd
	sntpd
	svnserve
	twistd
	varnishd
	wg-quick
"
gen_required_use_network() {
	local
	for pkg in ${NEEDS_NETWORK[@]} ; do
		echo "
			${pkg}? (
				^^ (
					hook-scripts
					netlink
				)
			)
		"
	done
}
REQUIRED_USE_NETWORK="
	$(gen_required_use_network)
"
REQUIRED_USE="
	${REQUIRED_USE_NETWORK}
	getty
	?? (
		hook-scripts
		netlink
	)
	?? (
		rsyslogd
		syslogd
	)
	docker? (
		containerd
	)
	ip6tables? (
		iptables
	)
"
RDEPEND="
	dash? (
		app-shells/dash
	)
"
PDEPEND="
	sys-apps/finit[hook-scripts?,netlink?]
	iwd? (
		sys-apps/finit[dbus]
	)
	networkmanager? (
		sys-apps/finit[dbus]
	)
	rtkit? (
		sys-apps/finit[dbus]
	)
	thermald? (
		sys-apps/finit[dbus]
	)
	varnishd? (
		sys-apps/finit[netlink]
	)
"

pkg_setup() {
	if [[ "${PV}" =~ "99999999" ]] ; then
einfo "This is the dev version."
	else
einfo "This is the live snapshot version."
	fi
ewarn
ewarn "For wireless, it is recommended to use one of the following instead:"
ewarn
ewarn "  FINIT_COND_NETWORK=\"hook/net/up\"      # needs sys-apps/finit[hook-scripts]"
ewarn "  FINIT_COND_NETWORK=\"net/wlan0/up\"     # needs sys-apps/finit[netlink]"
ewarn "  FINIT_COND_NETWORK=\"net/eth0/up\"      # needs sys-apps/finit[netlink]"
ewarn
ewarn "Prohibited for wireless:"
ewarn
ewarn "  FINIT_COND_NETWORK=\"net/route/default\""
ewarn
ewarn
ewarn "Place one of the above in /etc/portage/env/finit-d.conf"
ewarn
ewarn "Place the following in /etc/portage/package.env:"
ewarn
ewarn "  ${CATEGORY}/${PN} finit-d.conf"
ewarn
}

src_unpack() {
	cp -a "${FILESDIR}/dev/"* "${WORKDIR}" || die
	local libdir=$(get_libdir)
	sed -i \
		-e "s|lib64|${libdir}|g" \
		"confs/elogind.conf" \
		|| die
}

edit_cond_network() {
	IFS=$'\n'
	local L=(
		$(grep -r -l '__FINIT_COND_NETWORK__' ./)
	)
	local path
	for path in ${L[@]} ; do
		if [ -n "${FINIT_COND_NETWORK}" ] ; then
einfo "Using ${FINIT_COND_NETWORK} for network up for ${path}."
			sed -i -e "s|__FINIT_COND_NETWORK__|${FINIT_COND_NETWORK}|g" "${path}" || die
		else
einfo "Using net/route/default for network up for ${path}.  This conditon is bugged.  See metadata.xml for details on FINIT_COND_NETWORK."
			sed -i -e "s|__FINIT_COND_NETWORK__|net/route/default|g" "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

edit_dash() {
	IFS=$'\n'
	local L=(
		$(grep -r -l '#!/bin/sh' ./)
	)
	local path
	for path in ${L[@]} ; do
		if ! grep "^# BASH ME" "${path}" ; then
einfo "Editing ${path} for DASH"
			sed -i -e 's|#!/bin/sh|#!/bin/dash|g' "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

edit_pydoc() {
	has_version "dev-lang/python:3.10" || sed -i -e "/__PYDOC_3_10__/d" confs/pydoc.conf || die
	has_version "dev-lang/python:3.11" || sed -i -e "/__PYDOC_3_11__/d" confs/pydoc.conf || die
	has_version "dev-lang/python:3.12" || sed -i -e "/__PYDOC_3_12__/d" confs/pydoc.conf || die
}

edit_sql() {
	use mysql || return
	if ! has_version "dev-db/mysql" ; then
		sed -i -e "/__MYSQL__/d" confs/mysql.conf || die
	fi
	if ! has_version "dev-db/mariadb" ; then
		sed -i -e "/__MARIADB__/d" confs/mysql.conf || die
	fi
}

src_prepare() {
	default
	edit_cond_network
	edit_dash
	edit_pydoc
	edit_sql
}

install_script() {
	local script_name="${1}"
	exeinto /etc/finit.d/scripts
	doexe "${WORKDIR}/scripts/${script_name}"
	fowners root:root "/etc/finit.d/scripts/${script_name}"
	fperms 750 "/etc/finit.d/scripts/${script_name}"
}

src_install() {
	local svc
	for svc in ${SERVICES[@]} ; do
		if use ${svc} ; then
			insinto /etc/finit.d/available
			doins "${WORKDIR}/confs/${svc}.conf"
			dodir /etc/finit.d/enabled
			dosym \
				"/etc/finit.d/available/${svc}.conf" \
				"/etc/finit.d/enabled/${svc}.conf"
			if [[ -e "${WORKDIR}/scripts/${svc}-pre.sh" ]] ; then
				install_script "${svc}-pre.sh"
			fi
			if [[ -e "${WORKDIR}/scripts/${svc}.sh" ]] ; then
				install_script "${svc}.sh"
			fi
			if [[ -e "${WORKDIR}/scripts/${svc}-reload.sh" ]] ; then
				install_script "${svc}-reload.sh"
			fi
			if [[ -e "${WORKDIR}/scripts/${svc}-shutdown.sh" ]] ; then
				install_script "${svc}-shutdown.sh"
			fi
			if [[ -e "${WORKDIR}/scripts/${svc}-test.sh" ]] ; then
				install_script "${svc}-test.sh"
			fi
			if [[ -e "${WORKDIR}/scripts/${svc}-lib.sh" ]] ; then
				install_script "${svc}-lib.sh"
			fi
		fi
	done
	insinto /etc
	doins "${WORKDIR}/rc.local"
	doins "${WORKDIR}/finit.conf"
	install_script "lib.sh"
	if use apache ; then
		install_script "apache-configdump.sh"
		install_script "apache-fullstatus.sh"
		install_script "apache-graceful.sh"
		install_script "apache-graceful-stop.sh"
		install_script "apache-modules.sh"
		install_script "apache-virtualhosts.sh"
	fi
	if use inspircd ; then
		install_script "inspircd-version.sh"
	fi
	if use iptables ; then
		install_script "iptables-check.sh"
		install_script "iptables-panic.sh"
		install_script "iptables-save.sh"
		install_script "iptables-shutdown-pre.sh"
	fi
	if use mysql ; then
		install_script "mysql-bootstrap_galera.sh"
	fi
	if use nginx ; then
		install_script "nginx-upgrade.sh"
	fi
	if use squid ; then
		install_script "squid-rotate.sh"
	fi
	if use pydoc ; then
		has_version "dev-lang/python:3.10" && install_script "pydoc-3.10.sh"
		has_version "dev-lang/python:3.11" && install_script "pydoc-3.11.sh"
		has_version "dev-lang/python:3.12" && install_script "pydoc-3.12.sh"
	fi
	if use tor ; then
		install_script "tor-checkconfig.sh"
	fi
}

check_apache() {
	if use apache && ! grep -q -e "ServerName localhost" "${EROOT}/etc/apache2/httpd.conf" ; then
ewarn
ewarn "Apache needs \`ServerName localhost\` in /etc/apache2/httpd.conf for"
ewarn "localhost testers or developers."
ewarn

	fi
	if use apache && has_version "www-servers/apache[-apache2_modules_authz_core]" ; then
ewarn
ewarn "Apache requires apache2_modules_authz_core USE flag to avoid waiting"
ewarn "state in initctl."
ewarn
	fi
	if use apache && has_version "www-servers/apache[-apache2_modules_dir]" ; then
ewarn
ewarn "Apache requires apache2_modules_dir USE flag to avoid waiting state in"
ewarn "initctl."
ewarn
	fi
	if use apache && has_version "www-servers/apache[-apache2_modules_socache_shmcb]" ; then
ewarn
ewarn "Apache requires apache2_modules_socache_shmcb USE flag to avoid waiting"
ewarn "state in initctl."
ewarn
	fi
	if use apache && has_version "www-servers/apache[-apache2_modules_unixd]" ; then
ewarn
ewarn "Apache requires apache2_modules_unixd USE flag to avoid waiting state in"
ewarn "initctl."
ewarn
	fi
	if use apache && has_version "www-servers/apache[-ssl]" ; then
ewarn
ewarn "Apache requires ssl USE flag to avoid waiting state in initctl."
ewarn
	fi
}

check_actkbd() {
	if use actkbd && [ ! -e "${EROOT}/etc/actkbd.conf" ] ; then
		local pv=$(best_version "app-misc/actkbd" \
			| sed -i -e "s|app-misc/actkbd-||g")
ewarn
ewarn "Missing /etc/actkbd.conf which can list actkbd in initctl as crashed."
ewarn "Use the following to generate it:"
ewarn
ewarn "  bzcat /usr/share/doc/actkbd-${pv}/samples/actkbd.conf.bz2 > /etc/actkbd.conf"
ewarn
	fi
	if use actkbd && grep -q -F -e "<DEVICE>" "${EROOT}/etc/conf.d/actkbd" >/dev/null ; then
ewarn
ewarn "Detected <DEVICE> in /etc/conf.d/actkbd which can list actkbd in initctl"
ewarn "as crashed."
ewarn
	fi
}

check_fancontrol() {
	if use fancontrol && [ ! -e "/etc/fancontrol" ] ; then
ewarn
ewarn "Missing /etc/fancontrol which can list fancontrol in initctl as crashed."
ewarn "Use pwmconfig to fix this."
ewarn
	fi
}

check_mysql() {
	if use mysql && [ ! -e "${EROOT}/var/lib/mysql" ] ; then
ewarn
ewarn "Missing /var/lib/mysql folder"
ewarn
ewarn "You need to"
ewarn
ewarn "  \`emerge dev-db/mariadb --config\`"
ewarn
ewarn "or"
ewarn
ewarn "  \`emerge dev-db/mysql --config\`"
ewarn
ewarn "or you may get a crash in initctl."
ewarn
	fi
	if use mysql && has_version "dev-db/mariadb[-server]" ; then
ewarn
ewarn "dev-db/mariadb[server] is required for init script."
ewarn
	fi
	if use mysql && has_version "dev-db/mysql[-server]" ; then
ewarn
ewarn "dev-db/mysql[server] is required for init script."
ewarn
	fi
}

check_nginx() {
	if use nginx ; then
		if has_version "www-servers/nginx[-http]" ; then
ewarn
ewarn "www-servers/nginx[-http] may list nginx as crashed in initctl."
ewarn
		fi
		if has_version "www-servers/nginx[-nginx_modules_http_gzip]" ; then
ewarn
ewarn "www-servers/nginx[-nginx_modules_http_gzip] may list nginx as crashed in"
ewarn "initctl."
ewarn
		fi
	fi
}

check_pure_ftpd() {
	if use pure-ftpd && [ ! -f "/etc/pure-ftpd.conf" ] ; then
ewarn
ewarn "/etc/pure-ftpd.conf needs to be created"
ewarn
	fi
}

check_pure_uploadscript() {
	ftpd_configfile="/etc/pure-ftpd.conf"
	if use pure-ftpd && grep -q -e "# UPLOADSCRIPT" "/etc/conf.d/pure-uploadscript" ; then
ewarn
ewarn "UPLOADSCRIPT needs to be uncommented and point to the script to run."
ewarn
	fi
	if use pure-ftpd && ! grep -q -e "UPLOADSCRIPT" "/etc/conf.d/pure-uploadscript" ; then
ewarn
ewarn "UPLOADSCRIPT needs to be added to /etc/conf.d/pure-uploadscript and"
ewarn "point to the script to run."
ewarn
	fi
	if ! grep -q -e "^CallUploadScript" "${ftpd_configfile}" ; then
ewarn
ewarn "Enable CallUploadScript in ${ftpd_configfile}"
ewarn
	fi
}

check_svnserve() {
	if use svnserve && [ ! -e "${EROOT}/var/svn" ] ; then
ewarn
ewarn "Missing /var/svn which can list svnserve in initctl as waiting."
ewarn
	fi
}

check_varnishd() {
	if use varnishd && [ ! -e "${EROOT}/etc/varnish/default.vcl" ] ; then
ewarn
ewarn "Missing /etc/varnish/default.vcl which can list varnish in initctl as"
ewarn "waiting."
ewarn
	fi
}

check_znc() {
	if use znc && [ ! -e "${EROOT}/var/lib/znc/configs/znc.conf" ] ; then
ewarn
ewarn "Missing /var/lib/znc/configs/znc.conf which can list znc in initctl as"
ewarn "crashed."
ewarn
	fi
}

check_daemon_configs() {
	check_apache
	check_actkbd
	check_mysql
	check_pure_ftpd
	check_pure_uploadscript
	check_nginx
	check_varnishd
	check_znc
}

pkg_postinst() {
einfo "Send issues/requests to oiledmachine-overlay instead."
ewarn
ewarn "Your configs must be correct and exist or you may see crash listed in"
ewarn "initctl.  Debug messages are disabled."
ewarn
ewarn "You must use etc-update for changes to take effect."
ewarn "Save your work before running \`initctl reload\`."
ewarn
	if use netlink ; then
ewarn
ewarn "You may need to disconnect/reconnect not by automated means in order to"
ewarn "trigger network up event."
ewarn
	fi
	check_daemon_configs
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  pass-fail (99999999, 20230103)
# acpid - passed
# actkbd - passed
# apache - passed
# avahi-daemon - passed
# avahi-dnsconfd - failed
# bitlbee - passed
# bluetoothd/bluez - passed
# containerd - passed
# coolercontrol - passed
# cupsd - passed
# cpupower - passed
# dhcpcd - passed
# distccd - passed
# dmeventd - passed
# docker - passed
# elogind - passed
# fancontrol - passed
# getty - passed
# git - passed
# icecast - passed
# inspircd - failed
# iperf3 - passed
# iwd - passed
# laptop_mode - passed
# lm_sensors - passed
# mysql - passed
# NetworkManager - passed
# nginx - passed with security issue
# ntpd - passed
# redis - fail
# rtkit - passed
# seatd - passed
# spacenavd - passed
# squid - passed
# svnserve - failed
# thermald - passed (on test mode ; hardware not supported on dev machine)
# twistd - failed (upstream broken)
# tor - passed
# varnishd - passed
# varnishlog - passed
# varnishncsa - passed
# znc - passed

# Daemon permissions audit-review for required (99999999, 20230103)
# avahi - passed ; shows avahi:avahi
# bitcoin - tba ; needs bitcoin:bitcoin
# bitlbee - passed ; needs bitlbee:bitlbee
# distcc - passed ; needs distcc:?
# ergo - tba ; needs ergo:ergo
# git - pass ; needs nobody:nobody
# icecast - passed
# inspircd - tba ; needs inspircd:?
# mysql - passed ; shows mysql:mysql ; same as mariadb
# nginx - fail ; needs nginx:nginx for all process ; sets parent process to root:root and child with nginx:nginx ; tested for both direct exe and through script
# redis - tba ; needs redis:redis
# redis-sentinel - tba ; needs redis:redis
# rtkit - passed
# squid - passed
# tor - passed ; shows tor:tor
# znc - passed ; needs znc:znc

# Daemon permissions audit-review for not required (99999999, 20230103)
# acpid - not required ; show root:root
# actkbd - not required ; shows root:root
# bluetoothd - not required ; shows root:root
# containerd - not required ; shows root:root
# coolercontrol - required? ; shows root:root
# coolercontrol-liqctld - required? ; shows root:root
# cupsd - not required ; shows root:root
# dhcpcd ; shows root:root
# docker ; shows root:root ; has acct-group/docker but not in openrc init script
# elogind - not required ; shows root:root
# fancontrol - not required ; shows root:root
# iperf3 - not required ; shows root:root
# iwd - not required ; shows root:root
# networkmanager - not required ; shows root:root
# ntpd - not required ; shows root:root ; acct-user/openntpd has it
# seatd - not required ; shows root:root
# spacenavd - not required ; shows root:root
# wpa-supplicant - not required ; shows root:root
