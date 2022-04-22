# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake user

DESCRIPTION="Modular audio codec server"
HOMEPAGE="https://github.com/jketterl/codecserver"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" openrc systemd"
REQUIRED_USE="^^ ( openrc systemd )"
DEPEND+="
	acct-group/dialout
	>=dev-libs/protobuf-3.0
	openrc? ( sys-apps/openrc )
	systemd? ( sys-apps/systemd )
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.6
	>=dev-libs/protobuf-3.0
"
SRC_URI="
https://github.com/jketterl/codecserver/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( LICENSE README.md )

pkg_setup() {
	enewuser codecserver
	enewgroup codecserver
	esetgroups codecserver dialout
	esetgroups codecserver codecserver
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
