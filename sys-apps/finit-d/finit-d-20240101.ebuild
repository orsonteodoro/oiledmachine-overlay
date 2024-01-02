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
	watchdog
	xdm
	znc
)
IUSE+="
	${SERVICES[@]}
	r5
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
einfo "This is the snapshot version."
}

src_unpack() {
	cp -a "${FILESDIR}/dev/"* "${WORKDIR}" || die
	local libdir=$(get_libdir)
	sed -i \
		-e "s|lib64|${libdir}|g" \
		"confs/elogind.conf" \
		|| die
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
			if [[ -e "${WORKDIR}/scripts/${svc}-post.sh" ]] ; then
				install_script "${svc}-post.sh"
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
		install_script "inspircd-rehash.sh"
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

pkg_postinst() {
einfo "Send issues/requests to oiledmachine-overlay instead."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (4.6, 20230101)
# coolercontrol - passed
# cupsd - passed
# getty - passed
# NetworkManager - passed
