# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~amd64 ~arm64 ~ppc64"
S="${WORKDIR}"
SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${PV}.tar.xz
"

DESCRIPTION="Chromium sources"
HOMEPAGE="https://www.chromium.org/"
LICENSE="
	chromium-$(ver_cut 1-3 ${PV}).x.html
"
RESTRICT="binchecks mirror strip test"
SLOT="0/${PV}"
IUSE+=" ebuild-revision-2"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( )

src_unpack() {
	unpack ${A}
}

src_install() {
	dodir "/usr/share/chromium/sources"
	cp -aT "${WORKDIR}/chromium-${PV}" "${ED}/usr/share/chromium/sources" || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
