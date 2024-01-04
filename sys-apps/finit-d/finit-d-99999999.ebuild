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
	redis
	redis-sentinel
	rsyncd
	rtkit
	ntpd
	plymouth
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
	varnishncsd
	watchdog
	xdm
	znc
)
IUSE+="
	dash
	${SERVICES[@]}
"
REQUIRED_USE="
	getty
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
	apache? (
		sys-apps/finit[netlink]
	)
	bitcoind? (
		sys-apps/finit[netlink]
	)
	coolercontrol? (
		sys-apps/finit[netlink]
	)
	distccd? (
		sys-apps/finit[netlink]
	)
	icecast? (
		sys-apps/finit[netlink]
	)
	nginx? (
		sys-apps/finit[netlink]
	)
	iwd? (
		sys-apps/finit[dbus]
	)
	networkmanager? (
		sys-apps/finit[dbus]
	)
	ntpd? (
		sys-apps/finit[netlink]
	)
	rtkit? (
		sys-apps/finit[dbus]
	)
	sntpd? (
		sys-apps/finit[netlink]
	)
	svnserve? (
		sys-apps/finit[netlink]
	)
	thermald? (
		sys-apps/finit[dbus]
	)
	twistd? (
		sys-apps/finit[netlink]
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
}

src_unpack() {
	cp -a "${FILESDIR}/dev/"* "${WORKDIR}" || die
	local libdir=$(get_libdir)
	sed -i \
		-e "s|lib64|${libdir}|g" \
		"confs/elogind.conf" \
		|| die
}

src_prepare() {
	default
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
	if use tor ; then
		install_script "tor-checkconfig.sh"
	fi
}

check_daemon_configs() {
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
	if use actkbd && grep -F "<DEVICE>" "${EROOT}/etc/conf.d/actkbd" >/dev/null ; then
ewarn
ewarn "Detected <DEVICE> in /etc/conf.d/actkbd which can list actkbd in initctl"
ewarn "as crashed."
ewarn
	fi
	if use fancontrol && [ ! -e "/etc/fancontrol" ] ; then
ewarn
ewarn "Missing /etc/fancontrol which can list fancontrol in initctl as crashed."
ewarn "Use pwmconfig to fix this."
ewarn
	fi
	if use nginx ; then
		if has_version "www-servers/nginx[-http]" ; then
ewarn
ewarn "www-servers/nginx[-http] may list nginx as crashed in initctl."
ewarn
		fi
		if has_version "www-servers/nginx[-nginx_modules_http_gzip]" ; then
ewarn
ewarn "www-servers/nginx[-nginx_modules_http_gzip] may list nginx as crashed in initctl."
ewarn
		fi
	fi
	if use znc && [ ! -e "${EROOT}/var/lib/znc/configs/znc.conf" ] ; then
ewarn
ewarn "Missing /var/lib/znc/configs/znc.conf which can list znc in initctl as"
ewarn "crashed."
ewarn
	fi
}

pkg_postinst() {
einfo "Send issues/requests to oiledmachine-overlay instead."
ewarn
ewarn "Your configs must be correct and exist or you may see crash listed in"
ewarn "initctl.  Debug messages are disabled."
ewarn
ewarn "You must use etc-update for changes to take effect."
ewarn
	check_daemon_configs
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  pass-fail (99999999, 20230103)
# acpid - passed
# actkbd - passed
# apache - fail
# avahi-daemon - passed
# bitlbee - passed
# bluetoothd - fail (needs kernel config)
# containerd - passed
# coolercontrol - passed
# cupsd - passed
# distccd - passed
# docker - passed
# elogind - passed
# fancontrol - passed
# getty - passed
# icecast - passed
# inspircd - failed
# iperf3 - passed
# lm_sensors - passed
# mysql - fail
# NetworkManager - passed
# nginx - fail
# ntpd - passed
# redis - fail
# rtkit - passed
# seatd - passed
# spacenavd - passed
# squid - passed
# twistd - failed (upstream broken)
# varnishd - failed
# znc - passed

# Daemon permissions audit-review for required (99999999, 20230103)
# avahi - passed ; shows avahi:avahi
# bitcoin - tba ; needs bitcoin:bitcoin
# bitlbee - passed ; needs bitlbee:bitlbee
# distcc - passed ; needs distcc:?
# ergo - tba ; needs ergo:ergo
# git - tba ; needs nobody:nobody
# icecast - passed
# inspircd - tba ; needs inspircd:inspircd
# nginx - fail ; needs nginx:nginx for all process ; tested for both direct exe and through script
# redis - tba ; needs redis:redis
# redis-sentinel - tba ; needs redis:redis
# rtkit - passed
# znc - passed ; needs znc:znc

# Daemon permissions audit-review for not required (99999999, 20230103)
# acpid - not required ; show root:root
# actkbd - not required ; shows root:root
# containerd - not required ; shows root:root
# coolercontrol - required? ; shows root:root
# coolercontrol-liqctld - required? ; shows root:root
# cupsd - not required ; shows root:root
# docker ; shows root:root ; has acct-group/docker but not in openrc init script
# elogind - not required ; shows root:root
# fancontrol - not required ; shows root:root
# iperf3 - not required ; shows root:root
# networkmanager - not required ; shows root:root
# ntpd - not required ; shows root:root ; acct-user/openntpd has it
# seatd - not required ; shows root:root
# spacenavd - not required ; shows root:root
# wpa-supplicant - not required ; shows root:root
