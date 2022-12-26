# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="reddio is a command-line interface for Reddit written in POSIX sh"
HOMEPAGE="https://gitlab.com/aaronNG/reddio"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="auth"
RDEPEND="
	app-misc/jq
	net-misc/curl
	sys-apps/coreutils
	auth? (
		net-analyzer/netcat
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"
SRC_URI="
https://gitlab.com/aaronNG/reddio/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
	-> ${P}.tar.bz2
"
S="${WORKDIR}/${PN}-v${PV}"
RESTRICT="mirror"

src_compile() { :; }

src_install() {
	emake \
		DOCDIR="/usr/share/doc/${P}" \
		DESTDIR="${ED}" \
		PREFIX="/usr" \
		install
}
