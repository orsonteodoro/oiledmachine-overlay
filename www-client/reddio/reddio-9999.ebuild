# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="reddio is a command-line interface for Reddit written in POSIX sh"
HOMEPAGE="https://gitlab.com/aaronNG/reddio"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="auth fallback-commit"
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
SRC_URI=""
S="${WORKDIR}/${PN}-v${PV}"
RESTRICT="mirror"

src_unpack() {
	EGIT_REPO_URI="https://gitlab.com/aaronNG/reddio.git"
	EGIT_BRANCH="master"
	if use fallback-commit ; then
		EGIT_COMMIT="eab05356847283725863886a66866090466dab52"
	else
		EGIT_COMMIT="HEAD"
	fi
	git-r3_fetch
	git-r3_checkout
}

src_compile() { :; }

src_install() {
	emake \
		DOCDIR="/usr/share/doc/${P}" \
		DESTDIR="${ED}" \
		PREFIX="/usr" \
		install
	dodoc LICENSE
	einstalldocs
}
