# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://bugs.gentoo.org/822012

CFLAGS_HARDENED_LANGS="c-lang"

inherit meson-multilib

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
IUSE="test"
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
	local emesonargs=(
		-Dtests=$(usex test "enabled" "disabled")
	)
	meson-multilib_src_configure
}
