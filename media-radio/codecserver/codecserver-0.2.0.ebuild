# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake user-info

SRC_URI="
https://github.com/jketterl/codecserver/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

DESCRIPTION="Modular audio codec server"
HOMEPAGE="https://github.com/jketterl/codecserver"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" openrc systemd"
REQUIRED_USE="
	|| (
		openrc systemd
	)
"
DEPEND+="
	>=dev-libs/protobuf-3.12.4
	acct-group/dialout
	virtual/udev
	openrc? (
		sys-apps/openrc
	)
	systemd? (
		sys-apps/systemd
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.6
	>=dev-libs/protobuf-3.0
"
RESTRICT="mirror"
DOCS=( LICENSE README.md )

src_configure() {
	if ! egetent group ${PN} ; then
eerror
eerror "You must add the ${PN} group to the system."
eerror
eerror "  groupadd ${PN}"
eerror
		die
	fi
	if ! egetent passwd ${PN} ; then
eerror
eerror "You must add the ${PN} user to the system."
eerror
eerror "  useradd ${PN} -g ${PN} -G dialout -d /var/lib/${PN}"
eerror
		die
	fi
	if ! groups codecserver | grep -q -e "dialout" ; then
eerror
eerror "You must add the ${PN} user to the dialout group."
eerror
eerror "  gpasswd -a ${PN} dialout"
eerror
		die
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto /etc/codecserver
	doins conf/codecserver.conf
	if use openrc ; then
		exeinto /etc/init.d
		doexe "${FILESDIR}/init.d/${PN}"
	fi
	if ! use systemd ; then
		rm -rf "${ED}/lib/systemd" || die
	fi
}

pkg_postinst() {
	einfo
	einfo "The init script still needs to be started."
	einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
