# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://bugs.gentoo.org/822012

CFLAGS_HARDENED_LANGS="c-lang"
# It should be hardened if computer is on the university network or public network.
# Corporate network is assumed untrusted.
# GStreamer may use it as P2P.
CFLAGS_HARDENED_USE_CASES="network p2p untrusted-data"

inherit cflags-hardened meson-multilib

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/Avnu/libavtp/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Open source implementation of Audio Video Transport Protocol (AVTP) specified in IEEE 1722-2016 spec."
HOMEPAGE="https://github.com/Avnu/libavtp/tree/master"
LICENSE="BSD"
RESTRICT="test" # Untested
SLOT="0"
IUSE="
test
ebuild_revision_5
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/meson-0.46.0
	virtual/pkgconfig
"

src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Dtests=$(usex test "enabled" "disabled")
	)
	meson-multilib_src_configure
}
