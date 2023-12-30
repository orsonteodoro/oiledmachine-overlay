# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SRC_URI=""
S="${WORKDIR}"

DESCRIPTION="finit.d/*.conf files for finit init system"
HOMEPAGE="
https://troglobit.com/projects/finit/
https://github.com/troglobit/finit
"
LICENSE="
	MIT
"
#KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86" # Needs test
RESTRICT="mirror test"
SLOT="0"
SERVICES=(
	acpid
	apparmor
	bluetooth
	cron
	dmeventd
	elogind
	hostname
	lightdm
	modules
	ntpd
	rsyslogd
	sntpd
	syslogd
	watchdog
	anacron
	avahi-daemon
	consolefont
	dhcpcd
	dropbear
	getty
	keymap
	lxdm
	networkmanager
	plymouth-quit
	seatd
	sshd
	uuidd
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
                "elogind.conf" \
                || die
}

src_install() {
	local svc
	for svc in ${SERVICES[@]} ; do
		if use ${svc} ; then
			insinto /etc/finit.d/available
			doins "${FILESDIR}/${svc}.conf"
			dodir /etc/finit.d/enabled
			dosym \
				"/etc/finit.d/available/${svc}.conf" \
				"/etc/finit.d/enabled/${svc}.conf"
		fi
	done
	insinto /etc
	doins "${FILESDIR}/rc.local"
	doins "${FILESDIR}/finit.conf"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  passed (4.6, 20231230)
# NetworkManager - passed
# getty - passed
