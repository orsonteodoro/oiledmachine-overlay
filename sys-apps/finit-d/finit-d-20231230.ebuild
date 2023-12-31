# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
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
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
RESTRICT="mirror test"
SLOT="0"
SERVICES=(
	acpid
	apparmor
	anacron
	avahi-daemon
	bluez
	consolefont
	cups-browsed
	cupsd
	cron
	dhcpcd
	dmeventd
	dropbear
	elogind
	getty
	hostname
	keymap
	lightdm
	lm_sensors
	lxdm
	modules
	networkmanager
	nginx
	redis
	redis-sentinel
	ntpd
	plymouth
	rsyslogd
	seatd
	sntpd
	sshd
	syslogd
	uuidd
	watchdog
	xdm
)
IUSE+="
	${SERVICES[@]}
"
REQUIRED_USE="
	getty
"

src_unpack() {
	cp -a "${FILESDIR}"/* "${WORKDIR}" || die
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
			if [[ -e "${WORKDIR}/scripts/${svc}-shutdown.sh" ]] ; then
				install_script "${svc}-shutdown.sh"
			fi
		fi
	done
	insinto /etc
	doins "${WORKDIR}/rc.local"
	doins "${WORKDIR}/finit.conf"
	if use nginx ; then
		install_script "nginx-reload.sh"
		install_script "nginx-upgrade.sh"
		install_script "nginx-test-config.sh"
	fi
}

pkg_postinst() {
einfo "This package is always in development or live."
einfo "Send issues/requests to oiledmachine-overlay instead."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (4.6, 20231230)
# cupsd - passed
# getty - passed
# NetworkManager - passed
